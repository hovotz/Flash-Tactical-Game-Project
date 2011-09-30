package states 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fsm.State;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleActionSelectionState implements State
	{
		private static var instance:BattleActionSelectionState;
		
		private var _agent:*;
		
		public function BattleActionSelectionState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattleActionSelectionState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattleActionSelectionState {
			if (instance == null) {
				instance = new BattleActionSelectionState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
			_agent = agent;
			agent.getUnitActionsMenuForm().show();
			agent.getUnitActionsMenuForm().attackButton.addEventListener(MouseEvent.CLICK, onAttackButtonClickEvent);
			agent.getUnitActionsMenuForm().moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonClickEvent);
			agent.getUnitActionsMenuForm().waitButton.addEventListener(MouseEvent.CLICK, onWaitButtonClickEvent);
		}
		
		public function update(agent:*):void
		{
		}
		
		public function exit(agent:*):void
		{
			agent.getUnitActionsMenuForm().hide();
			agent.getUnitActionsMenuForm().attackButton.removeEventListener(MouseEvent.CLICK, onAttackButtonClickEvent);
			agent.getUnitActionsMenuForm().moveButton.removeEventListener(MouseEvent.CLICK, onMoveButtonClickEvent);
			agent.getUnitActionsMenuForm().waitButton.removeEventListener(MouseEvent.CLICK, onWaitButtonClickEvent);
		}
		
		private function onAttackButtonClickEvent(e:Event):void
		{
			_agent.getStateMachine().changeState(BattleDecideAttackState.getInstance());
		}
		
		private function onMoveButtonClickEvent(e:Event):void
		{
			_agent.getStateMachine().changeState(BattleDecideMoveState.getInstance());
		}
		
		private function onWaitButtonClickEvent(e:Event):void
		{
			_agent.getStateMachine().changeState(BattlePerformWaitState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}