package entities.units
{
	import entities.DamagePopUp;
	import entities.GameEntity;
	import flash.sampler.NewObjectSample;
	import messaging.MessageDispatcher;
	import events.UnitEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	import builders.Terrain;
	
	import graph.Node;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Unit extends GameEntity
	{
		public static const STANDING:String		= "standing";
		public static const DEAD:String			= "dead";
		public static const RUNNING:String		= "running";
		public static const JUMPING:String		= "jump";
		public static const ATTACKING:String	= "attack";
		
		public static const DOWN:String 		= "down";
		public static const DOWN_LEFT:String 	= "down_left";
		public static const LEFT:String 		= "left";
		public static const LEFT_UP:String 		= "left_up";
		public static const UP:String 			= "up";
		public static const UP_RIGHT:String		= "up_right";
		public static const RIGHT:String		= "right";
		public static const RIGHT_DOWN:String	= "right_down";
		
		public static const HP:String 		= "hp";
		public static const MAX_HP:String 	= "max_hp";
		public static const MP:String 		= "mp";
		public static const MAX_MP:String 	= "max_mp";
		
		protected var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		
		protected var _currentAnimation:String;
		private var _path:Array;
		private var _destX:int;
		private var _destY:int;
		private var _walkingSpeed:int = 180; // in seconds
		
		private var _isWalking:Boolean 		= false;
		private var _isAttacking:Boolean 	= false;
		private var _isDead:Boolean 		= false;
		
		protected var _spritemap:Spritemap;
		protected var _spriteWidth:Number = 50;
		protected var _spriteHeight:Number = 50;
		
		private var _picture:Image;
		private var _className:String;
		private var _maxHp:int;
		private var _hp:int;
		private var _maxMp:int;
		private var _mp:int;
		private var _movementRange:int;
		private var _attackRange:int;
		
		private var _animationState:String;
		private var _direction:String;
		
		public static function getAnimationName(animationState:String, direction:String):String
		{
			return animationState + "_" + direction;
		}
		
		public function setCurrentAnimation(animationState:String, direction:String):void
		{
			_animationState = animationState;
			_direction = direction;
			_currentAnimation = getAnimationName(animationState, direction);
		}
		
		public function set picture(value:Image):void
		{
			_picture = value;
		}
		
		public function get picture():Image
		{
			return _picture;
		}
		
		public function isWalking():Boolean
		{
			return _isWalking;
		}
		
		public function isDead():Boolean
		{
			return _isDead;
		}
		
		public function get className():String
		{
			return _className;
		}
		
		public function set className(value:String):void
		{
			_className = value;
		}
		
		public function get maxHp():int
		{
			return _maxHp;
		}
		
		public function set maxHp(value:int):void
		{
			_maxHp = value;
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.ATTRIBUTE_CHANGE, this, Unit.MAX_HP));
		}
		
		public function get hp():int
		{
			return _hp;
		}
		
		public function set hp(value:int):void
		{
			_hp = value;
			if (_hp <= 0) {
				_hp = 0;
				playAnimation(DEAD);
				_isDead = true;
			} else if (_hp > _maxHp) {
				_hp = _maxHp;
			}
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.ATTRIBUTE_CHANGE, this, Unit.HP));
		}
		
		public function get maxMp():int
		{
			return _maxMp;
		}
		
		public function set maxMp(value:int):void
		{
			_maxMp = value;
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.ATTRIBUTE_CHANGE, this, Unit.MAX_MP));
		}
		
		public function get mp():int
		{
			return _mp;
		}
		
		public function set mp(value:int):void
		{
			_mp = value;
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.ATTRIBUTE_CHANGE, this, Unit.MP));
		}
		
		public function get movementRange():int
		{
			return _movementRange;
		}
		
		public function set movementRange(value:int):void
		{
			_movementRange = value;
		}
		
		public function get attackRange():int
		{
			return _attackRange;
		}
		
		public function set attackRange(value:int):void
		{
			_attackRange = value;
		}
		
		public function set terrain(value:Terrain):void
		{
			_terrain = value;
		}
		
		public function set path(value:Array):void
		{
			_path = value;
		}
		
		public function get path():Array
		{
			return _path;
		}
		
		public function Unit(source:*, id:int, position:Point) 
		{
			super(id);
			_spritemap = new Spritemap(source, _spriteWidth, _spriteHeight);
			_spritemap.callback = animationCallback;
			_spritemap.x = -25;
			_spritemap.y = -20;
			
			setupSpritemap();
			graphic = _spritemap;
			setCurrentAnimation(STANDING, DOWN);
			_spritemap.play(_currentAnimation);
			x = position.x;
			y = position.y;
			
			setHitbox(_spriteWidth, _spriteHeight, 25, 20);
			
			_messageDispatcher = MessageDispatcher.getInstance();
		}
		
		public function setupSpritemap():void
		{
			setupStandingAnimations();
			setupRunningAnimations();
			setupJumpingAnimations();
			setupAttackingAnimations();
			setupDeadAnimations();
		}
		
		public function setupStandingAnimations():void
		{		
			_spritemap.add(getAnimationName(STANDING, DOWN),		[16], 0, false);
			_spritemap.add(getAnimationName(STANDING, DOWN_LEFT),	[17], 0, false);
			_spritemap.add(getAnimationName(STANDING, LEFT),		[18], 0, false);
			_spritemap.add(getAnimationName(STANDING, LEFT_UP),		[19], 0, false);
			_spritemap.add(getAnimationName(STANDING, UP),			[20], 0, false);
			_spritemap.add(getAnimationName(STANDING, UP_RIGHT),	[21], 0, false);
			_spritemap.add(getAnimationName(STANDING, RIGHT),		[22], 0, false);
			_spritemap.add(getAnimationName(STANDING, RIGHT_DOWN),	[23], 0, false);
		}
		
		public function setupRunningAnimations():void
		{
			_spritemap.add(getAnimationName(RUNNING, DOWN),			[24, 32, 40, 48], 9, true);
			_spritemap.add(getAnimationName(RUNNING, DOWN_LEFT),	[25, 33, 41, 49], 9, true);
			_spritemap.add(getAnimationName(RUNNING, LEFT),			[26, 34, 42, 50], 9, true);
			_spritemap.add(getAnimationName(RUNNING, LEFT_UP),		[27, 35, 43, 51], 9, true);
			_spritemap.add(getAnimationName(RUNNING, UP),			[28, 36, 44, 52], 9, true);
			_spritemap.add(getAnimationName(RUNNING, UP_RIGHT),		[29, 37, 45, 53], 9, true);
			_spritemap.add(getAnimationName(RUNNING, RIGHT),		[30, 38, 46, 54], 9, true);
			_spritemap.add(getAnimationName(RUNNING, RIGHT_DOWN),	[31, 39, 47, 55], 9, true);
		}
		
		public function setupJumpingAnimations():void
		{
			_spritemap.add(getAnimationName(JUMPING, DOWN),			[64, 56, 64], 9, true);
			_spritemap.add(getAnimationName(JUMPING, DOWN_LEFT),	[65, 57, 65], 9, true);
			_spritemap.add(getAnimationName(JUMPING, LEFT),			[66, 58, 66], 9, true);
			_spritemap.add(getAnimationName(JUMPING, LEFT_UP),		[67, 59, 67], 9, true);
			_spritemap.add(getAnimationName(JUMPING, UP),			[68, 60, 68], 9, true);
			_spritemap.add(getAnimationName(JUMPING, UP_RIGHT),		[69, 61, 69], 9, true);
			_spritemap.add(getAnimationName(JUMPING, RIGHT),		[70, 62, 70], 9, true);
			_spritemap.add(getAnimationName(JUMPING, RIGHT_DOWN),	[71, 63, 71], 9, true);
		}
		
		public function setupAttackingAnimations():void
		{
			_spritemap.add(getAnimationName(ATTACKING, DOWN), 		[128, 136, 144, 152, 160, 168], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, DOWN_LEFT), 	[129, 137, 145, 153, 161, 169], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, LEFT), 		[130, 138, 146, 154, 162, 170], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, LEFT_UP),	[131, 139, 147, 155, 163, 171], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, UP),			[132, 140, 148, 156, 164, 172], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, UP_RIGHT),	[133, 141, 149, 157, 165, 173], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, RIGHT), 		[134, 142, 150, 158, 166, 174], 15, false);
			_spritemap.add(getAnimationName(ATTACKING, RIGHT_DOWN),	[135, 143, 151, 159, 167, 175], 15, false);
		}
		
		public function setupDeadAnimations():void
		{
		}
		
		private function playAnimation(animationState:String):void
		{
			setCurrentAnimation(animationState, _direction);
		}
				
		private function animationCallback():void
		{
			playAnimation(STANDING);

			if (_isAttacking == true)
			{
				_isAttacking = false;
				_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.STOP_ATTACK));
			}
		}
		
		public function startWalkByPath():void
		{
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.START_MOVE));
			if (_path != null && _path.length > 0)
			{
				_path.shift();
				walkByPath();
			}
		}
		
		private function walkByPath():void
		{
			if(_path != null && _path.length > 0)
			{
				var node:Node = _path.shift();
				_destX = node.col * _terrain.cellSize;
				_destY = node.row * _terrain.cellSize;
				var destinationPointInSpace:Point = IsoUtils.isoToScreen(new Point3D(_destX, 0, _destY));
				_destX = destinationPointInSpace.x;
				_destY = destinationPointInSpace.y;
				var deltaX:int = _destX - this.x;
				var deltaY:int = _destY - this.y;
				walkTo(deltaX, deltaY);
			}
		}
		
		public function getDirectionNameFromVector(deltaX:Number, deltaY:Number):String
		{
			var name:String;
			
			if (deltaX == 0 && deltaY > 0)
				name = DOWN;
			else if (deltaX < 0 && deltaY > 0)
				name = DOWN_LEFT;
			else if (deltaX < 0 && deltaY == 0)
				name = LEFT;
			else if (deltaX < 0 && deltaY < 0)
				name = LEFT_UP;
			else if (deltaX == 0 && deltaY < 0)
				name = UP;
			else if (deltaX > 0 && deltaY < 0)
				name = UP_RIGHT;
			else if (deltaX > 0 && deltaY == 0)
				name = RIGHT;
			else if (deltaX > 0 && deltaY > 0)
				name = RIGHT_DOWN;

			return name;
		}
		
		private function walkTo(deltaX:Number, deltaY:Number):void
		{
			setCurrentAnimation(RUNNING, getDirectionNameFromVector(deltaX, deltaY));
			
			if (!_isWalking)
				_isWalking = true;
		}
		
		private function walking():void
		{
			var remainX:int = _destX - this.x;
			var remainY:int = _destY - this.y;
			var remainLength:Number = Math.sqrt(remainX * remainX + remainY * remainY);
			if (remainLength > (_walkingSpeed * FP.elapsed))
			{
				this.x += remainX / remainLength * (_walkingSpeed * FP.elapsed);
				this.y += remainY / remainLength * (_walkingSpeed * FP.elapsed);
			}
			else
			{
				this.x = _destX;
				this.y = _destY;
				
				if (_path != null && _path.length > 0)
				{
					walkByPath();
				}
				else
				{
					stopWalk();
				}
			}
		}
		
		private function stopWalk():void
		{
			var unitPositionInIsometricSpace:Point3D = IsoUtils.screenToIso(new Point(this.x, this.y));
			var col:int = unitPositionInIsometricSpace.x / _terrain.cellSize;
			var row:int = unitPositionInIsometricSpace.z / _terrain.cellSize;
			_terrain.setOccupied(col, row, true);
			_terrain.getNode(col, row).occupiedBy = this;
			playAnimation(STANDING);
			_isWalking = false;
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.STOP_MOVE));
		}
		
		public function attack(unit:Unit):void
		{
			var deltaX:int = unit.x - x;
			var deltaY:int = unit.y - y;
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.START_ATTACK));
			attackTo(deltaX, deltaY);
		
			unit.hp -= 1;
			var damagePopUp:DamagePopUp = new DamagePopUp(unit.x, unit.y, 1);
			world.add(damagePopUp);
		}
		
		public function attackTo(deltaX:int, deltaY:int):void
		{
			setCurrentAnimation(ATTACKING, getDirectionNameFromVector(deltaX, deltaY));
			
			if (!_isAttacking)
				_isAttacking = true;
		}
		
		override public function update():void
		{
			_spritemap.play(_currentAnimation);
			if (_isWalking)
			{
				walking();
			}
			super.update();
		}
	}
}