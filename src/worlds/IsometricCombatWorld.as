package worlds 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.aswing.border.EmptyBorder;
	
	import forms.UnitActionMenuForm;
	
	import org.aswing.*;
	import org.aswing.geom.IntDimension;
	
	import managers.UnitsManager;
	
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
	
	import entities.Hud;
	import entities.Bar;
	import entities.Selector;
	import entities.Highlight;
	
	import events.MessageDispatcher;
	import events.UnitEvent;
	
	import fsm.*;
	
	import states.BattleActionSelectionState;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class IsometricCombatWorld extends World 
	{
		private var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		private var _unitActionsMenuForm:UnitActionMenuForm;
		private var _stateMachine:StateMachine;
		private var _hud:Hud;
		private var _unitsManager:UnitsManager;
		private var _cameraHelper:CameraHelper;
		private var _selector:Selector;
		
		public function getUnitsManager():UnitsManager
		{
			return _unitsManager;
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
		
		public function IsometricCombatWorld() 
		{
			var terrainBuilder:TerrainBuilder = new TerrainBuilder(new IsomapTerrainBuilderStrategy());
			var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			_terrain = terrainBuilder.build(this, terrainGenerator.generate(50, 50), 30);
			
			_messageDispatcher = new MessageDispatcher();

			_selector = new Selector(this, _terrain);
			_selector.layer = 2;
			_selector.hide();
			add(_selector);
					
			_unitsManager = new UnitsManager(this, _terrain, _messageDispatcher);
			_unitsManager.createUnits();
			_unitsManager.focusFirstUnit();
			_cameraHelper = new CameraHelper(this, _terrain, _unitsManager.getUnitInFocus());
			_cameraHelper.focusTarget();
			
			_hud = new Hud();
			add(_hud);
			_hud.target = _unitsManager.getUnitInFocus();
			
			AsWingManager.setRoot(FP.engine);
			
			_unitActionsMenuForm = new UnitActionMenuForm(FP.engine, "Unit's Actions");
			_unitActionsMenuForm.changeAppearance(UnitActionMenuForm.NORMAL_APPEARANCE);
			_unitActionsMenuForm.setLocationXY(FP.width - _unitActionsMenuForm.getWidth(), FP.height - _unitActionsMenuForm.getHeight());

			_stateMachine = new StateMachine(this);
			_stateMachine.setCurrentState(BattleActionSelectionState.getInstance());
		}
		
		override public function update():void
		{
			_stateMachine.update();
			_cameraHelper.update();
			super.update();
		}

		public function highlightCurrentUnitMovementRange():void
		{
			var unitPositionInIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(_unitsManager.getUnitInFocus().x, _unitsManager.getUnitInFocus().y));
			var unitCol:int = unitPositionInIsometricSpace.x / _terrain.cellSize;
			var unitRow:int = unitPositionInIsometricSpace.z / _terrain.cellSize;
			_terrain.highlightCells(unitCol, unitRow, _unitsManager.getUnitInFocus().movement);
		}
				
		public function gotoNextUnit():void
		{
			_unitsManager.focusNextUnit();
			_hud.target = _unitsManager.getUnitInFocus();
			_cameraHelper.target = _unitsManager.getUnitInFocus();
			_cameraHelper.focusTarget();
		}
	}
}