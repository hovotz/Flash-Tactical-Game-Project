package worlds 
{
	import entities.bars.Bar;
	import entities.huds.Hud;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import managers.UnitsManager;
	import org.aswing.*;
	import punk.ui.PunkButton;
	
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	import com.hovotz.utilities.Grid;
	import com.hovotz.utilities.TerrainGenerator;
	
	import utilities.cameras.Camera;
	import utilities.isometricprojection.Point3D;
	import utilities.isometricprojection.IsoUtils;
	import utilities.builders.IsomapTerrainBuilderStrategy;
	import utilities.builders.Terrain;
	import utilities.builders.TerrainBuilder;
	
	import entities.selectors.IsometricSelector;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class IsometricCombatWorld extends World 
	{
		private var _hud:Hud;
		private var _unitsManager:UnitsManager;
		private var _camera:Camera;
		
		private var _terrain:Terrain;
		private var _xOffset:int;
		
		private var _isometricSelector:IsometricSelector;
		private var _mousePositionInIsometricSpace:Point3D;
		private var _isometricSelectorInIsometricSpaceCol:int;
		private var _isometricSelectorInIsometricSpaceRow:int;
		private var _isometricSelectorInIsometricSpaceX:int;
		private var _isometricSelectorInIsometricSpaceY:int;
		private var _isometricSelectorInScreen:Point;
		
		private var _frame:JFrame;
		private var _panel:JPanel;
		private var _attackButton:JButton;
		private var _moveButton:JButton;
		private var _waitButton:JButton;
		
		public function IsometricCombatWorld() 
		{
			var terrainBuilder:TerrainBuilder = new TerrainBuilder(new IsomapTerrainBuilderStrategy());
			var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			
			_terrain = terrainBuilder.build(terrainGenerator.generate(50, 50), 30);
			addTerrain(_terrain);
			_xOffset = _terrain.rows * _terrain.cellSize;
			
			_isometricSelector = new IsometricSelector();
			add(_isometricSelector);
			updateSelector();
			
			_camera = new Camera(this, new Rectangle( -_xOffset, 0, _terrain.width, _terrain.height), null);
			
			_unitsManager = new UnitsManager(this, _terrain);
			_unitsManager.createUnits();
			_unitsManager.focusFirstUnit();
			_camera = new Camera(this, new Rectangle( -_xOffset, 0, _terrain.width, _terrain.height), _unitsManager.getUnitInFocus());
			_camera.focusTarget();
			
			_hud = new Hud();
			add(_hud);
			_hud.target = _unitsManager.getUnitInFocus();
		}
		
		private function createGUI():void
		{
			AsWingManager.setRoot(FP.engine);
			
			_frame = new JFrame(FP.engine, "Unit's Actions");
			_panel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			_attackButton = new JButton("Attack");
			_attackButton.width = 100;
			_moveButton = new JButton("Move");
			_waitButton = new JButton("Wait");
			_panel.appendAll(_attackButton, _moveButton, _waitButton);
			
			_frame.setSizeWH(110, 400);
			_frame.setClosable(false);
			_frame.setResizable(false);
			_frame.getContentPane().append(_panel);
			_frame.show();
		}
		
		/*
		override public function begin():void
		{
			createGUI();
			super.begin();
		}
		*/
				
		private function switchUnit():void
		{
			_unitsManager.focusNextUnit();
			_hud.target = _unitsManager.getUnitInFocus();
			_camera.target = _unitsManager.getUnitInFocus();
			_camera.focusTarget();
		}
		
		private function addTerrain(terrain:Terrain):void
		{
			var entities:Array = terrain.entities;
			
			for (var i:int = 0; i < entities.length; i++)
			{
				add(entities[i]);
			}
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.TAB))
			{
				switchUnit();
			}
			
			if (!_unitsManager.getUnitInFocus().isWalking())
			{
				if (Input.pressed(Key.SPACE))
				{
					_unitsManager.getUnitInFocus().playJumpAnimation();
				} 
				if (Input.pressed(Key.A))
				{
					_unitsManager.getUnitInFocus().playAttackAnimation();
				} 
			}
			
			if (Input.mousePressed)
			{
				var inFocusPositionIsIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(_unitsManager.getUnitInFocus().x,_unitsManager.getUnitInFocus().y));
				
				var startCol:int = inFocusPositionIsIsometricSpace.x / _terrain.cellSize;
				var startRow:int = inFocusPositionIsIsometricSpace.z / _terrain.cellSize;
				var endCol:int = _isometricSelectorInIsometricSpaceCol;
				var endRow:int = _isometricSelectorInIsometricSpaceRow;
				
				if (endCol < 0 || endCol >= _terrain.cols ||
					endRow < 0 || endRow >= _terrain.rows)
				{
					trace("Cursor is outside the boundary of the terrain!");
				}
				else if (_terrain.isOccupied(endCol, endRow))
				{
					_terrain.setOccupied(endCol, endRow, false);
					if (_terrain.findPath(startCol, startRow, endCol, endRow))
					{
						_unitsManager.getUnitInFocus().path = _terrain.path;
						_unitsManager.getUnitInFocus().path.pop();
						_terrain.setOccupied(endCol, endRow, true);
						_unitsManager.getUnitInFocus().startWalkByPath();
					}
					else
					{
						trace("Unreachable cell!");
					}
				}
				else if (_terrain.isWalkable(endCol, endRow))
				{
					if (_terrain.findPath(startCol, startRow, endCol, endRow))
					{
						_unitsManager.getUnitInFocus().path = _terrain.path;
						_unitsManager.getUnitInFocus().startWalkByPath();
					}
					else
					{
						trace("Unreachable cell!");
					}
				}
				else
				{
					trace("tile is unwalkable");
				}
			}
			
			_camera.update();
			updateSelector();
			super.update();
		}
		
		private function updateSelector():void
		{
			_mousePositionInIsometricSpace = IsoUtils.screenToIso(new Point(Input.mouseX + this.camera.x, Input.mouseY + this.camera.y));
			
			_isometricSelectorInIsometricSpaceCol = (_mousePositionInIsometricSpace.x / _terrain.cellSize);
			_isometricSelectorInIsometricSpaceRow = (_mousePositionInIsometricSpace.z / _terrain.cellSize);
			_isometricSelectorInIsometricSpaceX =  _isometricSelectorInIsometricSpaceCol * _terrain.cellSize;
			_isometricSelectorInIsometricSpaceY =  _isometricSelectorInIsometricSpaceRow * _terrain.cellSize;
			
			if (_isometricSelectorInIsometricSpaceX < 0 || 
				_isometricSelectorInIsometricSpaceX >= (_terrain.cols * _terrain.cellSize) ||
				_isometricSelectorInIsometricSpaceY < 0 ||
				_isometricSelectorInIsometricSpaceY >= (_terrain.rows * _terrain.cellSize)) 
			{
				_isometricSelector.visible = false;
			}
			else 
			{	
				if (!_terrain.isWalkable(_isometricSelectorInIsometricSpaceCol, _isometricSelectorInIsometricSpaceRow))
				{
					_isometricSelector.show();
					_isometricSelector.cellIsUnWalkable();
				}
				else if (_terrain.isOccupied(_isometricSelectorInIsometricSpaceCol, _isometricSelectorInIsometricSpaceRow))
				{
					_isometricSelector.show();
					_isometricSelector.cellIsOccupied();
				}
				else
				{
					_isometricSelector.show();
					_isometricSelector.cellIsWalakble();
				}
				
				_isometricSelector.visible = true;
				_isometricSelectorInScreen = IsoUtils.isoToScreen(new Point3D(_isometricSelectorInIsometricSpaceX, 0, _isometricSelectorInIsometricSpaceY));
				_isometricSelector.x = _isometricSelectorInScreen.x;
				_isometricSelector.y = _isometricSelectorInScreen.y;
			}
		}
	}
}