package worlds 
{
	import entities.huds.Hud;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
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
	import entities.units.Unit;
	import entities.units.Swordman;
	import entities.units.Dragon;
	import entities.units.Archer;
	import entities.units.Ninja;
	import entities.units.Sorceror;
	import entities.units.Witch;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class IsometricCombatWorld extends World 
	{
		private var _hud:Hud;
		private var _units:Array;
		private var _inFocus:Unit;
		
		private var _terrain:Terrain;
		private var _xOffset:int;
		private var _camera:Camera;
		
		private var _isometricSelector:IsometricSelector;
		private var _mousePositionInIsometricSpace:Point3D;
		private var _isometricSelectorInIsometricSpaceCol:int;
		private var _isometricSelectorInIsometricSpaceRow:int;
		private var _isometricSelectorInIsometricSpaceX:int;
		private var _isometricSelectorInIsometricSpaceY:int;
		private var _isometricSelectorInScreen:Point;
		
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
			
			_units = new Array();
			createUnits();
			_inFocus = _units[0];
			_camera = new Camera(this, new Rectangle( -_xOffset, 0, _terrain.width, _terrain.height), _inFocus);
			_camera.focusTarget();
			
			_hud = new Hud();
			add(_hud);
			_hud.target = _inFocus;
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
				_camera.target = _inFocus;
				_camera.focusTarget();
			}
			
			if (Input.pressed(Key.SPACE))
			{
				if (!_inFocus.isWalking())
				{
					_inFocus.playAttackAnimation();
				}
			}
			
			if (Input.mousePressed)
			{
				var inFocusPositionIsIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(_inFocus.x, _inFocus.y));
				
				var startCol:int = inFocusPositionIsIsometricSpace.x / _terrain.cellSize;
				var startRow:int = inFocusPositionIsIsometricSpace.z / _terrain.cellSize;
				var endCol:int = _isometricSelectorInIsometricSpaceCol;
				var endRow:int = _isometricSelectorInIsometricSpaceRow;
				
				if (_terrain.isOccupied(endCol, endRow))
				{
					_terrain.setOccupied(endCol, endRow, false);
					if (_terrain.findPath(startCol, startRow, endCol, endRow))
					{
						_inFocus.path = _terrain.path;
						_inFocus.path.pop();
						_terrain.setOccupied(endCol, endRow, true);
						_inFocus.startWalkByPath();
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
						_inFocus.path = _terrain.path;
						_inFocus.startWalkByPath();
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
		
		private function switchUnit():void
		{
			var currentIndex:int = _units.indexOf(_inFocus);
			currentIndex++;
			currentIndex %= _units.length;
			_inFocus = _units[currentIndex];
			_hud.target = _inFocus;
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
					_isometricSelector.cellIsUnWalkable();
				}
				else if (_terrain.isOccupied(_isometricSelectorInIsometricSpaceCol, _isometricSelectorInIsometricSpaceRow))
				{
					_isometricSelector.cellIsOccupied();
				}
				else
				{
					_isometricSelector.cellIsWalakble();
				}
				
				_isometricSelector.visible = true;
				_isometricSelectorInScreen = IsoUtils.isoToScreen(new Point3D(_isometricSelectorInIsometricSpaceX, 0, _isometricSelectorInIsometricSpaceY));
				_isometricSelector.x = _isometricSelectorInScreen.x;
				_isometricSelector.y = _isometricSelectorInScreen.y;
			}
		}
		
		private function createUnits():void
		{

			var unit:Unit = new Swordman(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Dragon(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Archer(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Ninja(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Sorceror(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Witch(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
		}
		
		private function generateValidPosition():Point
		{
			var valid:Boolean = false;
			while (!valid)
			{
				var pCol:int = Math.random() * _terrain.cols;
				var pRow:int = Math.random() * _terrain.rows;
				valid = _terrain.isWalkable(pCol, pRow) && !_terrain.isOccupied(pCol, pRow);
			}
			_terrain.setOccupied(pCol, pRow, true);
			var unitPosition:Point = IsoUtils.isoToScreen(new Point3D(pCol * _terrain.cellSize, 0, pRow * _terrain.cellSize));
			return new Point(unitPosition.x, unitPosition.y);
		}
	}
}