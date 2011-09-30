package states 
{
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattlePerformAttackState implements State 
	{
		private static var instance:BattlePerformAttackState;
		
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
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
		}
	}
}

internal class SingletonEnforcer {
}