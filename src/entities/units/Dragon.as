package entities.units 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Dragon extends Unit 
	{
		public function Dragon(position:Point) 
		{
			super(Assets.DRAGON, position);
			_spritemap.y = -15;
			_className = "Dragon";
		}	
	}
}