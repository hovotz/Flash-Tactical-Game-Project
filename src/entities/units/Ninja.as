package entities.units 
{
	import events.MessageDispatcher;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Ninja extends Unit 
	{
		public function Ninja(position:Point, messageDispatcher:MessageDispatcher) 
		{
			super(Assets.NINJA, position, messageDispatcher);
			name = "Naruto";
			_className = "Ninja";
			hp = 2000;
			curHp = 2000;
			mp = 1000;
			curMp = 1000;
			movement = 15;
		}	
	}
}