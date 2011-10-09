package states 
{
	import builders.Terrain;
	import entities.Selector;
	import entities.units.Unit;
	import events.SelectorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.UnitActionMenuForm;
	import messaging.MessageDispatcher;
	import worlds.CombatWorld;
	import net.flashpunk.utils.Input;
	
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleDecideAttackState implements State 
	{
		private static var instance:BattleDecideAttackState;
		
		private var _combatWorld:CombatWorld;
		private var _terrain:Terrain;
		private var _unit:Unit;
		private var _selector:Selector;
		private var _unitActionsMenuForm:UnitActionMenuForm;
		private var _messageDispatcher:MessageDispatcher;
		
		public function BattleDecideAttackState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattleDecideAttackState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattleDecideAttackState {
			if (instance == null) {
				instance = new BattleDecideAttackState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
			_combatWorld 			= agent;
			_terrain 				= _combatWorld.getTerrain();
			_unit 					= _combatWorld.getUnitManager().getActiveUnit();
			_selector	 			= _combatWorld.getSelector();
			_unitActionsMenuForm 	= _combatWorld.getUnitActionsMenuForm();
			_messageDispatcher		= _combatWorld.getMessageDispatcher();
			
			_combatWorld.highlightActiveUnitAttackRange();
			_unitActionsMenuForm.cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClickEvent);
			_messageDispatcher.addEventListener(SelectorEvent.SELECTOR_CLICK, onSelectorClickEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			_terrain.unhighlightCells();
			_unitActionsMenuForm.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelButtonClickEvent);
			_messageDispatcher.removeEventListener(SelectorEvent.SELECTOR_CLICK, onSelectorClickEvent);
		}
		
		private function onSelectorClickEvent(se:SelectorEvent):void
		{
			if (se.node.occupied)
			{
				_unit.attack(se.node.occupiedBy);
				_combatWorld.getStateMachine().changeState(BattlePerformAttackState.getInstance());
			}
		}
		
		private function onCancelButtonClickEvent(e:Event):void
		{
			_combatWorld.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}