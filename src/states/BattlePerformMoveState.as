package states 
{
	import events.UnitEvent;
	
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattlePerformMoveState implements State 
	{
		private static var instance:BattlePerformMoveState;
		
		private var _agent:*;
		
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
			_agent = agent;
			agent.getUnitActionsMenuForm().hide();
			agent.getMessageDispatcher().addEventListener(UnitEvent.STOP_MOVE, onStopMoveEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			agent.getUnitActionsMenuForm().show();
			agent.getMessageDispatcher().removeEventListener(UnitEvent.STOP_MOVE, onStopMoveEvent);
		}
		
		private function onStopMoveEvent(ue:UnitEvent):void
		{
			_agent.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}