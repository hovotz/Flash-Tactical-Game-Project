package entities.units 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Sorceror extends Unit 
	{
		public function Sorceror(position:Point) 
		{
			super(Assets.SORCEROR, position);
			_className = "Sorceror";
		}	
	}
}