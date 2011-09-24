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
			name = "Zorro";
			_className = "Swordman";
			hp = 5000;
			curHp = 5000;
			mp = 500;
			curMp = 500;
		}	
	}
}