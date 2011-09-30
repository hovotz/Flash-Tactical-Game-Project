package states 
{
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattlePerformWaitState implements State 
	{
		private static var instance:BattlePerformWaitState;
		
		public function BattlePerformWaitState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattlePerformWaitState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattlePerformWaitState {
			if (instance == null) {
				instance = new BattlePerformWaitState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
		}
		
		public function update(agent:*):void
		{
			agent.gotoNextUnit();
			agent.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
		
		public function exit(agent:*):void
		{
		}
	}
}

internal class SingletonEnforcer {
}