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
			name = "Dibo";
			_className = "Dragon";
			hp = 5000;
			curHp = 5000;
			mp = 5000;
			curMp = 5000;
		}	
	}
}