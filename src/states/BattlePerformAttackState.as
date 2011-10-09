package states 
{
	import events.UnitEvent;
	import fsm.State;
	import worlds.CombatWorld;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattlePerformAttackState implements State 
	{
		private static var instance:BattlePerformAttackState;
		
		private var _combatWorld:CombatWorld;
		
		public function BattlePerformAttackState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattlePerformAttackState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattlePerformAttackState {
			if (instance == null) {
				instance = new BattlePerformAttackState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
			_combatWorld = agent;
			_combatWorld.getUnitActionsMenuForm().hide();
			_combatWorld.getMessageDispatcher().addEventListener(UnitEvent.STOP_ATTACK, onStopAttackEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			_combatWorld.getUnitActionsMenuForm().show();
			_combatWorld.getMessageDispatcher().removeEventListener(UnitEvent.STOP_ATTACK, onStopAttackEvent);
		}
		
		private function onStopAttackEvent(ue:UnitEvent):void
		{
			_combatWorld.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}