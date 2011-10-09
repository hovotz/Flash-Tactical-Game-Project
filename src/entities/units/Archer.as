package entities.units
{
	import entities.Arrow;
	import graph.Node;
	import messaging.MessageDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import utilities.IsoUtils;
	import utilities.Point3D;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Archer extends Unit 
	{
		public function Archer(id:int, position:Point) 
		{
			super(Assets.ARCHER, id, position);
			name = "Robin Hood";
			className = "Archer";
			maxHp = 1000;
			hp = 1000;
			maxMp = 1000;
			mp = 1000;
			movementRange = 5;
			attackRange = 10;
			picture = new Image(Assets.UNITS_PICTURE_STRIP, new Rectangle(50, 0, 50, 50));
		}
				
		override public function setupAttackingAnimations():void
		{
			_spritemap.add(getAnimationName(ATTACKING, DOWN), 		[120, 128, 136], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, DOWN_LEFT), 	[121, 129, 137], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, LEFT), 		[122, 130, 138], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, LEFT_UP), 	[123, 131, 139], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, UP), 		[124, 132, 140], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, UP_RIGHT),	[125, 133, 141], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, RIGHT), 		[126, 134, 142], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, RIGHT_DOWN),	[127, 135, 143], 15, false);
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
		
		override public function attack(unit:Unit):void
		{
			super.attack(unit);
			var arrow:Arrow = new Arrow(_currentAnimation, unit.x, unit.y);
			arrow.x = x;
			arrow.y = y;
			world.add(arrow);
		}
	}
}