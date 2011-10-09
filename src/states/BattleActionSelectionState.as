package states 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import worlds.CombatWorld;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import fsm.State;
	import builders.Terrain;
	import forms.UnitActionMenuForm;
	import entities.Selector;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleActionSelectionState implements State
	{
		private static var instance:BattleActionSelectionState;
		
		private var _combatWorld:CombatWorld;
		private var _terrain:Terrain;
		private var _selector:Selector;
		private var _unitActionsMenuForm:UnitActionMenuForm;
		
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
			_combatWorld 			= agent;
			_terrain 				= _combatWorld.getTerrain();
			_selector	 			= _combatWorld.getSelector();
			_unitActionsMenuForm 	= _combatWorld.getUnitActionsMenuForm();
			
			_unitActionsMenuForm.changeAppearance(UnitActionMenuForm.NORMAL_APPEARANCE);
			_unitActionsMenuForm.setLocationXY(FP.width - _unitActionsMenuForm.getWidth(), FP.height - _unitActionsMenuForm.getHeight());
			_unitActionsMenuForm.attackButton.addEventListener(MouseEvent.CLICK, onAttackButtonClickEvent);
			_unitActionsMenuForm.moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonClickEvent);
			_unitActionsMenuForm.waitButton.addEventListener(MouseEvent.CLICK, onWaitButtonClickEvent);
		}
		
		public function update(agent:*):void
		{
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
			_combatWorld.getStateMachine().changeState(BattleDecideAttackState.getInstance());
		}
		
		private function onMoveButtonClickEvent(e:Event):void
		{
			_combatWorld.getStateMachine().changeState(BattleDecideMoveState.getInstance());
		}
		
		private function onWaitButtonClickEvent(e:Event):void
		{
			_combatWorld.getStateMachine().changeState(BattlePerformWaitState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}