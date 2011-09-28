package entities.units 
{
	import events.MessageDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Witch extends Unit 
	{
		public function Witch(position:Point, messageDispatcher:MessageDispatcher) 
		{	
			super(Assets.WITCH, position, messageDispatcher);
			name = "Robin";
			_className = "Witch";
			hp = 500;
			curHp = 500;
			mp = 5000;
			curMp = 5000;
			movement = 3;
		}	
	}
}