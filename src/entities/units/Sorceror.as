package entities.units 
{
	import events.MessageDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Sorceror extends Unit 
	{
		public function Sorceror(position:Point, messageDispatcher:MessageDispatcher) 
		{
			super(Assets.SORCEROR, position, messageDispatcher);
			name = "Ultimecio";
			_className = "Sorceror";
			hp = 500;
			curHp = 500;
			mp = 5000;
			curMp = 5000;
			movement = 3;
		}	
	}
}