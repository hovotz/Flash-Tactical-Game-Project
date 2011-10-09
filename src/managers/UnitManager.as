package managers 
{
	import flash.geom.Point;
	
	import net.flashpunk.World;
	
	import messaging.MessageDispatcher;
	
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	import builders.Terrain;
	
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
	public class UnitManager 
	{
		public static const FIRST_UNIT:String 	= "first_unit";
		public static const NEXT_UNIT:String 	= "next_unit";
		public static const LAST_UNIT:String 	= "last_unit";
		
		private var _world:World;
		private var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		
		private var _units:Array;
		private var _activeUnit:Unit;
		private var _activeUnitIndex:int;
		
		private var _idCounter:int;
		
		public function UnitManager(world:World, terrain:Terrain)
		{
			_world = world;
			_terrain = terrain;
			_messageDispatcher = MessageDispatcher.getInstance();
			_units = new Array();
			createUnits();
			setActiveUnit(FIRST_UNIT);
		}
		
		public function getActiveUnit():Unit
		{
			return _activeUnit;
		}
		
		public function setActiveUnit(position:String):void
		{
			switch (position)
			{
				case FIRST_UNIT:
					_activeUnitIndex = 0;
					_activeUnit = _units[_activeUnitIndex];
					break;
					
				case NEXT_UNIT:
					do
					{
						_activeUnitIndex++;
						_activeUnitIndex %= _units.length;
						_activeUnit = _units[_activeUnitIndex];
					} while (_activeUnit.isDead());
					break;
					
				case LAST_UNIT:
					_activeUnitIndex = (_units.length - 1);
					_activeUnit = _units[_activeUnitIndex];
					break;
			}
		}
		
		public function createUnits():void
		{
			generateUnit("Swordman");
			generateUnit("Dragon");
			generateUnit("Archer");
			generateUnit("Ninja");
			generateUnit("Sorceror");
			generateUnit("Witch");
		}
		
		private function generateUnit(unitClass:String):Unit
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
			
			var unit:Unit;
			switch (unitClass)
			{
				case "Swordman":
					unit = new Swordman(_idCounter, unitPosition);
					break;
					
				case "Dragon":
					unit = new Dragon(_idCounter, unitPosition);
					break;
					
				case "Archer":
					unit = new Archer(_idCounter, unitPosition);
					break;
					
				case "Ninja":
					unit = new Ninja(_idCounter, unitPosition);
					break;
					
				case "Sorceror":
					unit = new Sorceror(_idCounter, unitPosition);
					break;
					
				case "Witch":
					unit = new Witch(_idCounter, unitPosition);
					break;
			}
			_idCounter++;
			unit.terrain = _terrain;
			_terrain.getNode(pCol, pRow).occupiedBy = unit;
			_world.add(unit);
			_units.push(unit);
			return unit;
		}
	}
}