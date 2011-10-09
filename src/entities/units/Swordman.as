package entities.units
{
	import messaging.MessageDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Swordman extends Unit 
	{
		public function Swordman(id:int, position:Point) 
		{
			super(Assets.SWORDMAN, id, position);
			name = "Zorro";
			className = "Swordsman";
			maxHp = 5000;
			hp = 5000;
			maxMp = 500;
			mp = 500;
			movementRange = 10;
			attackRange = 3;
			picture = new Image(Assets.UNITS_PICTURE_STRIP, new Rectangle(0, 0, 50, 50));
		}
		
		override public function setupDeadAnimations():void
		{
			_spritemap.add(getAnimationName(DEAD, DOWN),		[360], 0, false);
			_spritemap.add(getAnimationName(DEAD, DOWN_LEFT),	[361], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT),		[362], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT_UP),		[363], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP), 			[364], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP_RIGHT),	[365], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT), 		[366], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT_DOWN),	[367], 0, false);
		}
	}
}