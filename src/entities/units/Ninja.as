package entities.units 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Ninja extends Unit 
	{
		public function Ninja(position:Point) 
		{
			super(Assets.NINJA, position);
		}	
	}
}