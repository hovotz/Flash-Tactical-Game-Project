package states 
{
	import events.SelectorEvent;
	import flash.geom.Point;
	import forms.UnitActionMenuForm;
	import messaging.MessageDispatcher;
	import worlds.CombatWorld;
	import fsm.State;
	import entities.Selector;
	import net.flashpunk.utils.Input;
	import builders.Terrain;
	import entities.units.Unit;
	import events.UnitEvent;
	import utilities.Point3D;
	import utilities.IsoUtils;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleDecideMoveState implements State
	{
		private static var instance:BattleDecideMoveState;
		
		private var _combatWorld:CombatWorld;
		private var _terrain:Terrain;
		private var _unit:Unit;
		private var _selector:Selector;
		private var _unitActionsMenuForm:UnitActionMenuForm;
		private var _messageDispatcher:MessageDispatcher;
		
		public function BattleDecideMoveState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattleDecideMoveState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattleDecideMoveState {
			if (instance == null) {
				instance = new BattleDecideMoveState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
			_combatWorld 			= agent;
			_terrain 				= _combatWorld.getTerrain();
			_unit 					= _combatWorld.getUnitManager().getActiveUnit();
			_selector 				= _combatWorld.getSelector();
			_unitActionsMenuForm 	= _combatWorld.getUnitActionsMenuForm();
			_messageDispatcher		= _combatWorld.getMessageDispatcher();
			
			_combatWorld.highlightActiveUnitMovementRange();
			_unitActionsMenuForm.cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClickEvent);
			_messageDispatcher.addEventListener(UnitEvent.START_MOVE, onStartMoveEvent);
			_messageDispatcher.addEventListener(SelectorEvent.SELECTOR_CLICK, onSelectorClickEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			_terrain.unhighlightCells();
			_unitActionsMenuForm.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelButtonClickEvent);
			_messageDispatcher.removeEventListener(UnitEvent.START_MOVE, onStartMoveEvent);
			_messageDispatcher.removeEventListener(SelectorEvent.SELECTOR_CLICK, onSelectorClickEvent);
		}
		
		private function onSelectorClickEvent(se:SelectorEvent):void
		{			
			if(se.cellState == Selector.HIGHLIGHTED)
			{
				// Unit's position in isometric space
				var unitIS:Point3D = IsoUtils.screenToIso(new Point(_unit.x,_unit.y));
				var startCol:int = unitIS.x / _terrain.cellSize;
				var startRow:int = unitIS.z / _terrain.cellSize;
				var endCol:int = se.node.col;
				var endRow:int = se.node.row;
				
				if (_terrain.findPath(startCol, startRow, endCol, endRow))
				{
					_unit.path = _terrain.path;
					_unit.startWalkByPath();
				}
				else
				{
					trace("Unreachable cell!");
				}
			}
		}
		
		private function onStartMoveEvent(ue:UnitEvent):void
		{
			_combatWorld.getStateMachine().changeState(BattlePerformMoveState.getInstance());
		}
		
		private function onCancelButtonClickEvent(e:Event):void
		{
			_combatWorld.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}