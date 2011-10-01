package states 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleDecideAttackState implements State 
	{
		private static var instance:BattleDecideAttackState;
		
		private var _agent:*;
		
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
			_agent = agent;
			agent.getUnitActionsMenuForm().cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClickEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			agent.getUnitActionsMenuForm().cancelButton.removeEventListener(MouseEvent.CLICK, onCancelButtonClickEvent);
		}
		
		private function onCancelButtonClickEvent(e:Event):void
		{
			_agent.getStateMachine().changeState(BattleActionSelectionState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}