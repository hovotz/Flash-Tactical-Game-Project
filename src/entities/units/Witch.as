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
			name = "Robin";
			_className = "Witch";
			hp = 500;
			curHp = 500;
			mp = 5000;
			curMp = 5000;
		}	
	}
}