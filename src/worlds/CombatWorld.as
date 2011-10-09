package worlds 
{
	import events.SelectorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Text;
	import org.aswing.border.EmptyBorder;
	import org.aswing.event.TableModelListener;
	
	import forms.UnitActionMenuForm;
	
	import org.aswing.*;
	import org.aswing.geom.IntDimension;
	
	import managers.UnitManager;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import graph.Node;
	import graph.Grid;
	import algorithms.AStar;
	import generators.TerrainGenerator;
	
	import utilities.CameraHelper;
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	import builders.Terrain;
	import builders.TerrainBuilder;
	import builders.IsomapTerrainBuilderStrategy;
	
	import entities.huds.HudController;
	import entities.Bar;
	import entities.Selector;
	import entities.Highlight;
	
	import messaging.MessageDispatcher;
	import events.UnitEvent;
	
	import fsm.*;
	
	import states.BattleActionSelectionState;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class CombatWorld extends World 
	{
		private var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		private var _unitActionsMenuForm:UnitActionMenuForm;
		private var _stateMachine:StateMachine;
		private var _hudController:HudController;
		private var _unitManager:UnitManager;
		private var _cameraHelper:CameraHelper;
		private var _selector:Selector;
		
		public function getUnitManager():UnitManager
		{
			return _unitManager;
		}
		
		public function getMessageDispatcher():MessageDispatcher
		{
			return _messageDispatcher;
		}
		
		public function getTerrain():Terrain
		{
			return _terrain;
		}
		
		public function getSelector():Selector
		{
			return _selector;
		}
		
		public function getStateMachine():StateMachine
		{
			return _stateMachine;
		}
		
		public function getUnitActionsMenuForm():UnitActionMenuForm
		{
			return _unitActionsMenuForm;
		}
		
		public function CombatWorld() 
		{
			Text.font = "Arial Font";
			var terrainBuilder:TerrainBuilder = new TerrainBuilder(new IsomapTerrainBuilderStrategy());
			var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			_terrain = terrainBuilder.build(this, terrainGenerator.generate(50, 50), 30);
			
			_messageDispatcher = MessageDispatcher.getInstance();

			_selector = new Selector(this, _terrain);
			_selector.layer = 2;
			add(_selector);
					
			_unitManager = new UnitManager(this, _terrain);
			
			_cameraHelper = new CameraHelper(this, _terrain, _unitManager.getActiveUnit());
			_cameraHelper.focusTarget();
			
			_hudController = new HudController();
			add(_hudController);
			_hudController.setActiveUnit(_unitManager.getActiveUnit());
			
			AsWingManager.setRoot(FP.engine);
			
			_unitActionsMenuForm = new UnitActionMenuForm(FP.engine, "Unit's Actions");
			_unitActionsMenuForm.changeAppearance(UnitActionMenuForm.NORMAL_APPEARANCE);
			_unitActionsMenuForm.setLocationXY(FP.width - _unitActionsMenuForm.getWidth(), FP.height - _unitActionsMenuForm.getHeight());
			_unitActionsMenuForm.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverEvent);
			_unitActionsMenuForm.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutEvent);

			_stateMachine = new StateMachine(this);
			_stateMachine.setCurrentState(BattleActionSelectionState.getInstance());
			
			_messageDispatcher.addEventListener(SelectorEvent.SELECTOR_ROLLOVER, onSelectorRollOverEvent);
		}
		
		private function onSelectorRollOverEvent(se:SelectorEvent):void
		{
			switch (se.cellState)
			{
				case Selector.OCCUPIED:
					_hudController.setTargetUnit(se.node.occupiedBy);
					break;
					
				case Selector.EMPTY:
					_hudController.setTargetUnit(null);
					break;
			}
		}
		
		override public function update():void
		{
			_stateMachine.update();
			_cameraHelper.update();
			super.update();
		}
		
		public function highlightActiveUnitAttackRange():void
		{
			var unitPositionInIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(_unitManager.getActiveUnit().x, _unitManager.getActiveUnit().y));
			var unitCol:int = unitPositionInIsometricSpace.x / _terrain.cellSize;
			var unitRow:int = unitPositionInIsometricSpace.z / _terrain.cellSize;
			_terrain.highlightCells(_terrain.getAttackRangeNodes(unitCol, unitRow, _unitManager.getActiveUnit().attackRange));
		}
		
		public function highlightActiveUnitMovementRange():void
		{
			var unitPositionInIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(_unitManager.getActiveUnit().x, _unitManager.getActiveUnit().y));
			var unitCol:int = unitPositionInIsometricSpace.x / _terrain.cellSize;
			var unitRow:int = unitPositionInIsometricSpace.z / _terrain.cellSize;
			_terrain.highlightCells(_terrain.getMovementRangeNodes(unitCol, unitRow, _unitManager.getActiveUnit().movementRange));
		}
				
		public function gotoNextUnit():void
		{
			_unitManager.setActiveUnit(UnitManager.NEXT_UNIT);
			_hudController.setActiveUnit( _unitManager.getActiveUnit());
			_cameraHelper.target = _unitManager.getActiveUnit();
			_cameraHelper.focusTarget();
		}
		
		private function onMouseOverEvent(me:MouseEvent):void
		{
			_selector.hide();
		}
		
		private function onMouseOutEvent(me:MouseEvent):void
		{
			_selector.show();
		}
	}
}