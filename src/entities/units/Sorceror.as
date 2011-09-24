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
			name = "Ultimecio";
			_className = "Sorceror";
			hp = 500;
			curHp = 500;
			mp = 5000;
			curMp = 5000;
		}	
	}
}