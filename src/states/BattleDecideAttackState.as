package states 
{
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleDecideAttackState implements State 
	{
		private static var instance:BattleDecideAttackState;
		
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