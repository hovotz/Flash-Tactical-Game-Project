package fsm 
{
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class StateMachine 
	{
		private var _owner:*;
		private var _currentState:State;
		private var _previousState:State;
		private var _globalState:State;
		
		public function StateMachine(owner:*) 
		{
			_owner = owner;
			_currentState = null;
			_previousState = null;
			_globalState = null;
		}
		
		public function update():void
		{
			if (_globalState)
			{
				_globalState.update(_owner);
			}
				
			if (_currentState)
			{
				_currentState.update(_owner);
			}
		}
		
		public function changeState(newState:State):void
		{
			_previousState = _currentState;
			_currentState.exit(_owner);
			_currentState = newState;
			_currentState.enter(_owner);
		}
		
		public function gotoPreviousState():void
		{
			changeState(_previousState);
		}
		
		public function setCurrentState(value:State):void
		{
			_currentState = value;
			_currentState.enter(_owner);
		}
		
		public function getCurrentState():State
		{
			return _currentState;
		}
		
		public function setPreviousState(value:State):void
		{
			_previousState = value;
		}
		
		public function getPreviousState():State
		{
			return _previousState;
		}
		
		public function setGlobalState(value:State):void
		{
			_globalState = value;
		}
		
		public function getGlobalState():State
		{
			return _globalState;
		}
	}
}