package managers 
{
	import events.MessageDispatcher;
	import flash.geom.Point;
	
	import net.flashpunk.World;
	
	import utilities.isometricprojection.IsoUtils;
	import utilities.isometricprojection.Point3D;
	
	import utilities.builders.Terrain;
	
	import entities.units.Unit;
	import entities.units.Swordman;
	import entities.units.Dragon;
	import entities.units.Archer;
	import entities.units.Ninja;
	import entities.units.Sorceror;
	import entities.units.Witch;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class UnitsManager 
	{
		private var _world:World;
		private var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		
		private var _units:Array;
		private var _unitInFocus:Unit;
		
		public function UnitsManager(world:World, terrain:Terrain, messageDispatcher:MessageDispatcher)
		{
			_world = world;
			_terrain = terrain;
			_messageDispatcher = messageDispatcher;
			
			_units = new Array();
		}
		
		public function getUnitInFocus():Unit
		{
			return _unitInFocus;
		}
		
		public function focusFirstUnit():void
		{
			_unitInFocus = _units[0];
		}
		
		public function focusNextUnit():void
		{
			var currentIndex:int = _units.indexOf(_unitInFocus);
			currentIndex++;
			currentIndex %= _units.length;
			_unitInFocus = _units[currentIndex];
		}
		
		public function createUnits():void
		{
			var unit:Unit = new Swordman(generateValidPosition(), _messageDispatcher);
			unit.terrain = _terrain;
			unit.layer = 1;
			_world.add(unit);
			_units.push(unit);
			
			unit = new Dragon(generateValidPosition(), _messageDispatcher);
			unit.terrain = _terrain;
			_world.add(unit);
			_units.push(unit);
			
			unit = new Archer(generateValidPosition(), _messageDispatcher);
			unit.terrain = _terrain;
			_world.add(unit);
			_units.push(unit);
			
			unit = new Ninja(generateValidPosition(), _messageDispatcher);
			unit.terrain = _terrain;
			_world.add(unit);
			_units.push(unit);
			
			unit = new Sorceror(generateValidPosition(), _messageDispatcher);
			unit.terrain = _terrain;
			_world.add(unit);
			_units.push(unit);
			
			unit = new Witch(generateValidPosition(), _messageDispatcher);
			unit.terrain = _terrain;
			_world.add(unit);
			_units.push(unit);
		}
		
		private function generateValidPosition():Point
		{
			var valid:Boolean = false;
			while (!valid)
			{
				var pCol:int = Math.random() * _terrain.cols;
				var pRow:int = Math.random() * _terrain.rows;
				valid = _terrain.isWalkable(pCol, pRow) && !_terrain.isOccupied(pCol, pRow);
			}
			_terrain.setOccupied(pCol, pRow, true);
			var unitPosition:Point = IsoUtils.isoToScreen(new Point3D(pCol * _terrain.cellSize, 0, pRow * _terrain.cellSize));
			return new Point(unitPosition.x, unitPosition.y);
		}
	}
}