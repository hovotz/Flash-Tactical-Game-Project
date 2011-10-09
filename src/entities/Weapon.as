package entities 
{
	import entities.units.Unit;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Weapon 
	{
		private var _owner:Unit;
		
		public function Weapon(owner:Unit) 
		{
			_owner = owner;
		}
		
		public function attack(unit:Unit):void
		{
		}
	}
}