package entities 
{
	import entities.units.Unit;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Arrow extends Entity 
	{	
		private var _spritemap:Spritemap;
		private var _currentAnimation:String;
		private var _projectingSpeed:int = 500;
		private var _isProjecting:Boolean = false;
		private var _destX:int;
		private var _destY:int;
		
		public function Arrow(currentAnimation:String, destX:int, destY:int) 
		{
			_spritemap = new Spritemap(Assets.ARCHER, 50, 50);
			_spritemap.x = -25;
			_spritemap.y = -20;
			setupSpritemap();
			graphic = _spritemap;
			_spritemap.play(currentAnimation);
			_destX = destX;
			_destY = destY;
			_isProjecting = true;
		}
		
		public function setupSpritemap():void
		{
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.DOWN), 		[144], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.DOWN_LEFT), 	[145], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.LEFT), 		[146], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.LEFT_UP),		[147], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.UP), 			[148], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.UP_RIGHT),	[149], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.RIGHT), 		[150], 0, false);
			_spritemap.add(Unit.getAnimationName(Unit.ATTACKING, Unit.RIGHT_DOWN),	[151], 0, false);
		}
		
		public function projecting():void
		{
			var remainX:int = _destX - this.x;
			var remainY:int = _destY - this.y;
			var remainLength:Number = Math.sqrt(remainX * remainX + remainY * remainY);
			if (remainLength > (_projectingSpeed * FP.elapsed))
			{
				this.x += remainX / remainLength * (_projectingSpeed * FP.elapsed);
				this.y += remainY / remainLength * (_projectingSpeed * FP.elapsed);
			}
			else
			{
				this.x = _destX;
				this.y = _destY;
				stopProjecting();
			}
		}
		
		public function stopProjecting():void
		{
			_isProjecting = false;
			world.remove(this);
		}
		
		override public function update():void
		{
			if (_isProjecting)
			{
				projecting();
			}
			super.update();
		}
	}
}