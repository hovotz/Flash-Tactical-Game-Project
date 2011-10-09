package states 
{
	import events.UnitEvent;
	import worlds.CombatWorld;
	
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattlePerformMoveState implements State 
	{
		private static var instance:BattlePerformMoveState;
		
		private var _combatWorld:CombatWorld;
		
		public function BattlePerformMoveState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattlePerformMoveState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattlePerformMoveState {
			if (instance == null) {
				instance = new BattlePerformMoveState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
			_combatWorld = agent;
			_combatWorld.getUnitActionsMenuForm().hide();
			_combatWorld.getMessageDispatcher().addEventListener(UnitEvent.STOP_MOVE, onStopMoveEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			_combatWorld.getUnitActionsMenuForm().show();
			_combatWorld.getMessageDispatcher().removeEventListener(UnitEvent.STOP_MOVE, onStopMoveEvent);
		}
		
		private function onStopMoveEvent(ue:UnitEvent):void
		{
			_combatWorld.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}