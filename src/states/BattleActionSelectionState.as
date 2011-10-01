package states 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import fsm.State;
	
	import forms.UnitActionMenuForm;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleActionSelectionState implements State
	{
		private static var instance:BattleActionSelectionState;
		
		private var _agent:*;
		private var _unitActionsMenuForm:UnitActionMenuForm;
		
		private var _oldMouseX:int;
		private var _oldMouseY:int;
		
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
			_unitActionsMenuForm = agent.getUnitActionsMenuForm();
			_unitActionsMenuForm.changeAppearance(UnitActionMenuForm.NORMAL_APPEARANCE);
			_unitActionsMenuForm.setLocationXY(FP.width - _unitActionsMenuForm.getWidth(), FP.height - _unitActionsMenuForm.getHeight());
			_unitActionsMenuForm.attackButton.addEventListener(MouseEvent.CLICK, onAttackButtonClickEvent);
			_unitActionsMenuForm.moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonClickEvent);
			_unitActionsMenuForm.waitButton.addEventListener(MouseEvent.CLICK, onWaitButtonClickEvent);
		}
		
		public function update(agent:*):void
		{
			if (Input.mousePressed)
			{
				_oldMouseX = Input.mouseX;
				_oldMouseY = Input.mouseY;
			}
			
			if (Input.mouseDown)
			{
				agent.camera.x += _oldMouseX - Input.mouseX;
				agent.camera.y += _oldMouseY - Input.mouseY;
				agent.camera.x = (agent.camera.x < -agent.getTerrain().xOffset) ? -agent.getTerrain().xOffset : agent.camera.x;
				agent.camera.x = (agent.camera.x > (-agent.getTerrain().xOffset + agent.getTerrain().width - FP.width)) ? -agent.getTerrain().xOffset + agent.getTerrain().width - FP.width : agent.camera.x;
				agent.camera.y = (agent.camera.y < 0) ? 0 : agent.camera.y;
				agent.camera.y = (agent.camera.y > (agent.getTerrain().height - FP.height)) ? agent.getTerrain().height - FP.height : agent.camera.y;
				
				_oldMouseX = Input.mouseX;
				_oldMouseY = Input.mouseY;
			}
		}
		
		public function exit(agent:*):void
		{
			_unitActionsMenuForm.changeAppearance(UnitActionMenuForm.CANCEL_APPEARANCE);
			_unitActionsMenuForm.setLocationXY(FP.width - _unitActionsMenuForm.getWidth(), FP.height - _unitActionsMenuForm.getHeight());
			_unitActionsMenuForm.attackButton.removeEventListener(MouseEvent.CLICK, onAttackButtonClickEvent);
			_unitActionsMenuForm.moveButton.removeEventListener(MouseEvent.CLICK, onMoveButtonClickEvent);
			_unitActionsMenuForm.waitButton.removeEventListener(MouseEvent.CLICK, onWaitButtonClickEvent);
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