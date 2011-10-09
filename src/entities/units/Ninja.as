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
	public class Ninja extends Unit 
	{
		public function Ninja(id:int, position:Point) 
		{
			super(Assets.NINJA, id, position);
			name = "Naruto";
			className = "Ninja";
			maxHp = 2000;
			hp = 2000;
			maxMp = 1000;
			mp = 1000;
			movementRange = 15;
			attackRange = 3;
			picture = new Image(Assets.UNITS_PICTURE_STRIP, new Rectangle(100, 0, 50, 50));
		}	
		
		override public function setupDeadAnimations():void
		{
			_spritemap.add(getAnimationName(DEAD, DOWN),		[232], 0, false);
			_spritemap.add(getAnimationName(DEAD, DOWN_LEFT),	[233], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT),		[234], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT_UP),		[235], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP), 			[236], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP_RIGHT),	[237], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT), 		[238], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT_DOWN),	[239], 0, false);
		}
	}
}