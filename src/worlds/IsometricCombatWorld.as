package worlds 
{
	import com.hovotz.utilities.AStar;
	import entities.bars.Bar;
	import entities.highlights.Highlight;
	import entities.huds.Hud;
	import events.MessageDispatcher;
	import events.UnitEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import managers.UnitsManager;
	import org.aswing.*;
	import org.aswing.geom.IntDimension;
	import punk.ui.PunkButton;
	
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	import com.hovotz.utilities.Node;
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
		private var _terrain:Terrain;
		private var _xOffset:int;
		private var _messageDispatcher:MessageDispatcher;
		
		private var _hud:Hud;
		private var _unitsManager:UnitsManager;
		private var _camera:Camera;
		
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
		
		private var _highlightedNodeList:Array;
		private var _highlightList:Array;
		
		public static const NORMAL_STATE:String = "normal_state";
		public static const ATTACK_STATE:String = "attack_state";
		public static const MOVE_STATE:String 	= "move_state";
		public static const WAIT_STATE:String	= "wait_state";
		
		private var _currentState:String = NORMAL_STATE;
		
		public function IsometricCombatWorld() 
		{
			
			var terrainBuilder:TerrainBuilder = new TerrainBuilder(new IsomapTerrainBuilderStrategy());
			var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			_terrain = terrainBuilder.build(terrainGenerator.generate(50, 50), 30);
			addTerrain(_terrain);
			_xOffset = _terrain.rows * _terrain.cellSize;
			
			_messageDispatcher = new MessageDispatcher();
			_messageDispatcher.addEventListener(UnitEvent.STOP_MOVE, onUnitStopMove);
			
			_isometricSelector = new IsometricSelector();
			_isometricSelector.layer = 2;
			add(_isometricSelector);
			updateSelector();
			
			_camera = new Camera(this, new Rectangle( -_xOffset, 0, _terrain.width, _terrain.height), null);
			
			_unitsManager = new UnitsManager(this, _terrain, _messageDispatcher);
			_unitsManager.createUnits();
			_unitsManager.focusFirstUnit();
			_camera = new Camera(this, new Rectangle( -_xOffset, 0, _terrain.width, _terrain.height), _unitsManager.getUnitInFocus());
			_camera.focusTarget();
			
			_hud = new Hud();
			add(_hud);
			_hud.target = _unitsManager.getUnitInFocus();
		}
		
		private function onUnitStopMove(e:UnitEvent):void
		{
			_currentState = IsometricCombatWorld.NORMAL_STATE;
			for each (var node:Node in _highlightedNodeList)
			{
				node.highlighted = false;
			}
			removeList(_highlightList);
			_frame.show();
			trace("Unit Stop Move");
		}
		
		private function createGUI():void
		{
			AsWingManager.setRoot(FP.engine);
			
			_frame = new JFrame(FP.engine, "Unit's Actions");
			_frame.setLocationXY(0, 480 - 117);
			_panel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			_frame.setSizeWH(117, 125);
			_frame.setClosable(false);
			_frame.setResizable(false);
			_frame.setDragable(false);
			
			_attackButton = new JButton("Attack");
			_attackButton.setPreferredSize(new IntDimension(100, 25));
			_attackButton.addEventListener(MouseEvent.CLICK, onAttackButtonClickEvent);
			
			_moveButton = new JButton("Move");
			_moveButton.setPreferredSize(new IntDimension(100, 25));
			_moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonClickEvent);
			
			_waitButton = new JButton("Wait");
			_waitButton.setPreferredSize(new IntDimension(100, 25));
			_waitButton.addEventListener(MouseEvent.CLICK, onWaitButtonClickEvent);
			
			_panel.appendAll(_attackButton, _moveButton, _waitButton);
			_frame.getContentPane().append(_panel);
			_frame.show();
		}
		
		private function onAttackButtonClickEvent(e:Event):void
		{
			_currentState = IsometricCombatWorld.ATTACK_STATE;
		}
		
		private function onMoveButtonClickEvent(e:Event):void
		{
			_frame.hide();
			var unitPositionInIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(_unitsManager.getUnitInFocus().x, _unitsManager.getUnitInFocus().y));
			var unitCol:int = unitPositionInIsometricSpace.x / _terrain.cellSize;
			var unitRow:int = unitPositionInIsometricSpace.z / _terrain.cellSize;
			highlightCells(unitCol, unitRow, _unitsManager.getUnitInFocus().movement);
			_currentState = IsometricCombatWorld.MOVE_STATE;
		}
		
		private function onWaitButtonClickEvent(e:Event):void
		{
			switchUnit();
			_currentState = IsometricCombatWorld.WAIT_STATE;
		}
		
		override public function begin():void
		{
			createGUI();
			super.begin();
		}
				
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
			switch(_currentState)
			{
				case IsometricCombatWorld.NORMAL_STATE:
					break;
					
				case IsometricCombatWorld.ATTACK_STATE:
					break;
					
				case IsometricCombatWorld.MOVE_STATE:
					moveState();
					break;
					
				case IsometricCombatWorld.WAIT_STATE:
					break;
			}
			
			_camera.update();
			super.update();
		}
		
		private function moveState():void
		{
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
				else if (_terrain.isHighlighted(endCol, endRow))
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
			updateSelector();
		}
		
		private function highlightCells(col:int, row:int, distance:int):void
		{
			var astar:AStar = new AStar();
			_highlightedNodeList = astar.findMovementRange(col, row, distance, _terrain.grid);
			_highlightList = new Array();
			for (var i:int = 0; i < _highlightedNodeList.length; i++)
			{
				var node:Node = _highlightedNodeList[i];
				node.highlighted = true;
				
				var highlightPositionInScreenSpace:Point = IsoUtils.isoToScreen(new Point3D(node.col * _terrain.cellSize, 0, node.row * _terrain.cellSize))
				var highlight:Highlight = new Highlight();
				highlight.x = highlightPositionInScreenSpace.x;
				highlight.y = highlightPositionInScreenSpace.y;
				highlight.layer = 3;
				_highlightList.push(highlight);
				add(highlight);
			}
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
				if (!_terrain.isHighlighted(_isometricSelectorInIsometricSpaceCol, _isometricSelectorInIsometricSpaceRow))
				{
					_isometricSelector.show();
					_isometricSelector.cellIsUnWalkable();
				}
				else if (_terrain.isHighlighted(_isometricSelectorInIsometricSpaceCol, _isometricSelectorInIsometricSpaceRow))
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