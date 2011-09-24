package entities.units
{
	import flash.geom.Point;
	
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Swordman extends Unit 
	{
		public function Swordman(position:Point) 
		{
			super(Assets.SWORDMAN, position);
			_className = "Swordman";
		}	
	}
}