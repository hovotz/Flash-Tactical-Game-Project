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
			name = "Robin Hood";
			_className = "Archer";
			hp = 1000;
			curHp = 1000;
			mp = 1000;
			curMp = 1000;
		}	
	}
}