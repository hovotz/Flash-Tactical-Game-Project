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
			name = "Naruto";
			_className = "Ninja";
			hp = 2000;
			curHp = 2000;
			mp = 1000;
			curMp = 1000;
		}	
	}
}