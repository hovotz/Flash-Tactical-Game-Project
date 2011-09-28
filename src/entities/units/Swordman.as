package entities.units
{
	import events.MessageDispatcher;
	import flash.geom.Point;
	
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Swordman extends Unit 
	{
		public function Swordman(position:Point, messageDispatcher:MessageDispatcher) 
		{
			super(Assets.SWORDMAN, position, messageDispatcher);
			name = "Zorro";
			_className = "Swordsman";
			hp = 5000;
			curHp = 5000;
			mp = 500;
			curMp = 500;
			movement = 10;
		}	
	}
}