package entities.units 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Witch extends Unit 
	{
		public function Witch(position:Point) 
		{	
			super(Assets.WITCH, position);
			_className = "Witch";
		}	
	}
}