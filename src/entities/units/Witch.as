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
	public class Witch extends Unit 
	{
		public function Witch(id:int, position:Point) 
		{	
			super(Assets.WITCH, id, position);
			name = "Robin";
			className = "Witch";
			maxHp = 500;
			hp = 500;
			maxMp = 5000;
			mp = 5000;
			movementRange = 3;
			attackRange = 1;
			picture = new Image(Assets.UNITS_PICTURE_STRIP, new Rectangle(250, 0, 50, 50));
		}
		
		override public function setupDeadAnimations():void
		{
			_spritemap.add(getAnimationName(DEAD, DOWN),		[208], 0, false);
			_spritemap.add(getAnimationName(DEAD, DOWN_LEFT),	[209], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT),		[210], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT_UP),		[211], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP), 			[212], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP_RIGHT),	[213], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT), 		[214], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT_DOWN),	[215], 0, false);
		}
	}
}