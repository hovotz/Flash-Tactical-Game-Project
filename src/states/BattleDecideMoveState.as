package states 
{
	import flash.geom.Point;
	
	import fsm.State;
	
	import entities.Selector;
	
	import net.flashpunk.utils.Input;
	
	import builders.Terrain;
	import entities.units.Unit;
	import events.UnitEvent;
	
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class BattleDecideMoveState implements State
	{
		private static var instance:BattleDecideMoveState;
		
		private var _agent:*;
		private var _terrain:Terrain;
		private var _unit:Unit;
		private var _selector:Selector;
		
		public function BattleDecideMoveState(key:SingletonEnforcer) 
		{
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use BattleDecideMoveState.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():BattleDecideMoveState {
			if (instance == null) {
				instance = new BattleDecideMoveState(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function enter(agent:*):void
		{
			_agent = agent;
			_terrain = agent.getTerrain();
			_unit = agent.getUnitsManager().getUnitInFocus();
			_selector = agent.getSelector();
			agent.highlightCurrentUnitMovementRange();
			agent.getSelector().show()
			agent.getMessageDispatcher().addEventListener(UnitEvent.START_MOVE, onStartMoveEvent);
		}
		
		public function update(agent:*):void
		{
			if (Input.mousePressed)
			{
				// Unit's position in isometric space
				var unitIS:Point3D = IsoUtils.screenToIso(new Point(_unit.x,_unit.y));
				
				var startCol:int = unitIS.x / _terrain.cellSize;
				var startRow:int = unitIS.z / _terrain.cellSize;
				var endCol:int = _selector.ISCol;
				var endRow:int = _selector.ISRow;
				
				if (endCol < 0 || endCol >= _terrain.cols ||
					endRow < 0 || endRow >= _terrain.rows)
				{
					trace("Cursor is outside the boundary of the terrain!");
				}
				else if (_terrain.isHighlighted(endCol, endRow))
				{
					if (_terrain.findPath(startCol, startRow, endCol, endRow))
					{
						_unit.path = _terrain.path;
						_unit.startWalkByPath();
					}
					else
					{
						trace("Unreachable cell!");
					}
				}
				else
				{
					trace("tile is unwalkable");
				}
			}
		}
		
		public function exit(agent:*):void
		{
			agent.getSelector().hide();
			agent.getMessageDispatcher().removeEventListener(UnitEvent.START_MOVE, onStartMoveEvent);
		}
		
		private function onStartMoveEvent(ue:UnitEvent):void
		{
			_agent.getStateMachine().changeState(BattlePerformMoveState.getInstance());
		}
	}
}

internal class SingletonEnforcer {
}