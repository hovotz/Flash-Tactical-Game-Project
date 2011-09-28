package entities.units 
{
	import events.MessageDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Dragon extends Unit 
	{
		public function Dragon(position:Point, messageDispatcher:MessageDispatcher) 
		{
			super(Assets.DRAGON, position, messageDispatcher);
			_spritemap.y = -15;
			name = "Dibo";
			_className = "Dragon";
			hp = 5000;
			curHp = 5000;
			mp = 5000;
			curMp = 5000;
			movement = 15;
		}	
	}
}