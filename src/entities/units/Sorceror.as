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
	public class Sorceror extends Unit 
	{
		public function Sorceror(id:int, position:Point) 
		{
			super(Assets.SORCEROR, id, position);
			name = "Ultimecio";
			className = "Sorceror";
			maxHp = 500;
			hp = 500;
			maxMp = 5000;
			mp = 5000;
			movementRange = 3;
			attackRange = 1;
			picture = new Image(Assets.UNITS_PICTURE_STRIP, new Rectangle(200, 0, 50, 50));
		}
		
		override public function setupDeadAnimations():void
		{
			_spritemap.add(getAnimationName(DEAD, DOWN),		[200], 0, false);
			_spritemap.add(getAnimationName(DEAD, DOWN_LEFT),	[201], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT),		[202], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT_UP),		[203], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP), 			[204], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP_RIGHT),	[205], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT), 		[206], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT_DOWN),	[207], 0, false);
		}
	}
}