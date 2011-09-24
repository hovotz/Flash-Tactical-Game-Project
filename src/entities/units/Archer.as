package entities.units
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Archer extends Unit 
	{
		public function Archer(position:Point) 
		{
			super(Assets.ARCHER, position);
			_className = "Archer";
		}	
	}
}