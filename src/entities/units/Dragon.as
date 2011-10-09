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
	public class Dragon extends Unit 
	{
		public function Dragon(id:int, position:Point) 
		{
			super(Assets.DRAGON, id, position);
			_spritemap.y = -15;
			name = "Dibo";
			className = "Dragon";
			maxHp = 5000;
			hp = 5000;
			maxMp = 5000;
			mp = 5000;
			movementRange = 15;
			attackRange = 3;
			picture = new Image(Assets.UNITS_PICTURE_STRIP, new Rectangle(150, 0, 50, 50));
		}	
		
		override public function setupDeadAnimations():void
		{
			_spritemap.add(getAnimationName(DEAD, DOWN),		[264], 0, false);
			_spritemap.add(getAnimationName(DEAD, DOWN_LEFT),	[265], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT),		[266], 0, false);
			_spritemap.add(getAnimationName(DEAD, LEFT_UP),		[267], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP), 			[268], 0, false);
			_spritemap.add(getAnimationName(DEAD, UP_RIGHT),	[269], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT), 		[270], 0, false);
			_spritemap.add(getAnimationName(DEAD, RIGHT_DOWN),	[271], 0, false);
		}
	}
}