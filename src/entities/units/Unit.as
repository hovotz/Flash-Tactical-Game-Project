package entities.units
{
	import events.MessageDispatcher;
	import events.UnitEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
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
	public class Unit extends Entity 
	{		
		public static const STAND_DOWN:String 			= "stand_down";
		public static const STAND_DOWN_LEFT:String 		= "stand_down_left";
		public static const STAND_LEFT:String 			= "stand_left";
		public static const STAND_LEFT_UP:String		= "stand_left_up";
		public static const STAND_UP:String				= "stand_up";
		public static const STAND_UP_RIGHT:String		= "stand_up_right";
		public static const STAND_RIGHT:String			= "stand_right";
		public static const STAND_RIGHT_DOWN:String 	= "stand_right_down";
		
		public static const RUN_DOWN:String				= "run_down";
		public static const RUN_DOWN_LEFT:String		= "run_down_left";
		public static const RUN_LEFT:String				= "run_left";
		public static const RUN_LEFT_UP:String			= "run_left_up";
		public static const RUN_UP:String				= "run_up";
		public static const RUN_UP_RIGHT:String			= "run_up_right";
		public static const RUN_RIGHT:String			= "run_right";
		public static const RUN_RIGHT_DOWN:String		= "run_right_down";
		
		public static const JUMP_DOWN:String			= "jump_down";
		public static const JUMP_DOWN_LEFT:String		= "jump_down_left";
		public static const JUMP_LEFT:String			= "jump_left";
		public static const JUMP_LEFT_UP:String			= "jump_left_up";
		public static const JUMP_UP:String				= "jump_up";
		public static const JUMP_UP_RIGHT:String		= "jump_up_right";
		public static const JUMP_RIGHT:String			= "jump_right";
		public static const JUMP_RIGHT_DOWN:String 		= "jump_right_down";
		
		public static const ATTACK_DOWN:String			= "attack_down";
		public static const ATTACK_DOWN_LEFT:String		= "attack_down_left";
		public static const ATTACK_LEFT:String			= "attack_left";
		public static const ATTACK_LEFT_UP:String		= "attack_left_up";
		public static const ATTACK_UP:String			= "attack_up";
		public static const ATTACK_UP_RIGHT:String		= "attack_up_right";
		public static const ATTACK_RIGHT:String			= "attack_right";
		public static const ATTACK_RIGHT_DOWN:String 	= "attack_right_down";
		
		private var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		
		private var _currentAnimation:String = Unit.STAND_DOWN;
		private var _path:Array;
		private var _isWalking:Boolean = false;
		private var _destX:int;
		private var _destY:int;
		private var _walkingSpeed:Number = 3;
		
		protected var _spritemap:Spritemap;
		protected var _spriteWidth:Number = 50;
		protected var _spriteHeight:Number = 50;
		
		protected var _className:String;
		protected var _hp:int;
		protected var _curHp:int;
		protected var _mp:int;
		protected var _curMp:int;
		protected var _movement:int;
		
		public function isWalking():Boolean
		{
			return _isWalking;
		}
		
		public function get className():String
		{
			return _className;
		}
		
		public function get hp():int
		{
			return _hp;
		}
		
		public function set hp(value:int):void
		{
			_hp = value;
		}
		
		public function get curHp():int
		{
			return _curHp;
		}
		
		public function set curHp(value:int):void
		{
			_curHp = value;
		}
		
		public function get mp():int
		{
			return _mp;
		}
		
		public function set mp(value:int):void
		{
			_mp = value;
		}
		
		public function get curMp():int
		{
			return _curMp;
		}
		
		public function set curMp(value:int):void
		{
			_curMp = value;
		}
		
		public function get movement():int
		{
			return _movement;
		}
		
		public function set movement(value:int):void
		{
			_movement = value;
		}
		
		public function Unit(source:*, position:Point, messageDispatcher:MessageDispatcher) 
		{	
			_spritemap = new Spritemap(source, _spriteWidth, _spriteHeight);
			_spritemap.callback = animationCallback;
			// top view settings
			//_spritemap.x = -10;
			//_spritemap.y = -20;

			// isometric view settings
			_spritemap.x = -25;
			_spritemap.y = -20;
			
			setupSpritemap();
			graphic = _spritemap;
			_spritemap.play(_currentAnimation);
			x = position.x;
			y = position.y;
			
			//setHitbox(_spriteWidth, _spriteHeight, 10, 20);
			setHitbox(_spriteWidth, _spriteHeight, 25, 20);
			
			_messageDispatcher = messageDispatcher;
		}
		
		public function setupSpritemap():void
		{
			_spritemap.add(Unit.STAND_DOWN, 		[16], 0, false);
			_spritemap.add(Unit.STAND_DOWN_LEFT, 	[17], 0, false);
			_spritemap.add(Unit.STAND_LEFT, 		[18], 0, false);
			_spritemap.add(Unit.STAND_LEFT_UP,		[19], 0, false);
			_spritemap.add(Unit.STAND_UP, 			[20], 0, false);
			_spritemap.add(Unit.STAND_UP_RIGHT,		[21], 0, false);
			_spritemap.add(Unit.STAND_RIGHT, 		[22], 0, false);
			_spritemap.add(Unit.STAND_RIGHT_DOWN,	[23], 0, false);
			
			_spritemap.add(Unit.RUN_DOWN, 			[24, 32, 40, 48], 9, true);
			_spritemap.add(Unit.RUN_DOWN_LEFT, 		[25, 33, 41, 49], 9, true);
			_spritemap.add(Unit.RUN_LEFT, 			[26, 34, 42, 50], 9, true);
			_spritemap.add(Unit.RUN_LEFT_UP, 		[27, 35, 43, 51], 9, true);
			_spritemap.add(Unit.RUN_UP, 			[28, 36, 44, 52], 9, true);
			_spritemap.add(Unit.RUN_UP_RIGHT,		[29, 37, 45, 53], 9, true);
			_spritemap.add(Unit.RUN_RIGHT, 			[30, 38, 46, 54], 9, true);
			_spritemap.add(Unit.RUN_RIGHT_DOWN,		[31, 39, 47, 55], 9, true);
			
			_spritemap.add(Unit.JUMP_DOWN, 			[64, 56, 64], 9, true);
			_spritemap.add(Unit.JUMP_DOWN_LEFT, 	[65, 57, 65], 9, true);
			_spritemap.add(Unit.JUMP_LEFT, 			[66, 58, 66], 9, true);
			_spritemap.add(Unit.JUMP_LEFT_UP, 		[67, 59, 67], 9, true);
			_spritemap.add(Unit.JUMP_UP, 			[68, 60, 68], 9, true);
			_spritemap.add(Unit.JUMP_UP_RIGHT,		[69, 61, 69], 9, true);
			_spritemap.add(Unit.JUMP_RIGHT, 		[70, 62, 70], 9, true);
			_spritemap.add(Unit.JUMP_RIGHT_DOWN,	[71, 63, 71], 9, true);
			
			_spritemap.add(Unit.ATTACK_DOWN, 		[128, 136, 144, 152, 160, 168], 15, false);
			_spritemap.add(Unit.ATTACK_DOWN_LEFT, 	[129, 137, 145, 153, 161, 169], 15, false);
			_spritemap.add(Unit.ATTACK_LEFT, 		[130, 138, 146, 154, 162, 170], 15, false);
			_spritemap.add(Unit.ATTACK_LEFT_UP, 	[131, 139, 147, 155, 163, 171], 15, false);
			_spritemap.add(Unit.ATTACK_UP, 			[132, 140, 148, 156, 164, 172], 15, false);
			_spritemap.add(Unit.ATTACK_UP_RIGHT,	[133, 141, 149, 157, 165, 173], 15, false);
			_spritemap.add(Unit.ATTACK_RIGHT, 		[134, 142, 150, 158, 166, 174], 15, false);
			_spritemap.add(Unit.ATTACK_RIGHT_DOWN,	[135, 143, 151, 159, 167, 175], 15, false);
		}
		
		private function setCurrentAnimationBaseOnDirection(deltaX:Number, deltaY:Number):void
		{
			if (deltaX == 0 && deltaY > 0)
			{
				_currentAnimation = Unit.RUN_DOWN;
			}
			if (deltaX < 0 && deltaY > 0)
			{
				_currentAnimation = Unit.RUN_DOWN_LEFT;
			}
			if (deltaX < 0 && deltaY == 0)
			{
				_currentAnimation = Unit.RUN_LEFT;
			}
			if (deltaX < 0 && deltaY < 0)
			{
				_currentAnimation = Unit.RUN_LEFT_UP;
			}
			if (deltaX == 0 && deltaY < 0)
			{
				_currentAnimation = Unit.RUN_UP;
			}
			if (deltaX > 0 && deltaY < 0)
			{
				_currentAnimation = Unit.RUN_UP_RIGHT;
			}
			if (deltaX > 0 && deltaY == 0)
			{
				_currentAnimation = Unit.RUN_RIGHT;
			}
			if (deltaX > 0 && deltaY > 0)
			{
				_currentAnimation = Unit.RUN_RIGHT_DOWN;
			}
		}
		
		private function stopRunning():void
		{
			switch (_currentAnimation)
			{
				case Unit.RUN_DOWN:
					_currentAnimation = Unit.STAND_DOWN;
					break;
					
				case Unit.RUN_DOWN_LEFT:
					_currentAnimation = Unit.STAND_DOWN_LEFT;
					break;
					
				case Unit.RUN_LEFT: 
					_currentAnimation = Unit.STAND_LEFT;
					break;
					
				case Unit.RUN_LEFT_UP: 
					_currentAnimation = Unit.STAND_LEFT_UP;
					break;

				case Unit.RUN_UP:
					_currentAnimation = Unit.STAND_UP;
					break;
					
				case Unit.RUN_UP_RIGHT:
					_currentAnimation = Unit.STAND_UP_RIGHT;
					break;
					
				case Unit.RUN_RIGHT:
					_currentAnimation = Unit.STAND_RIGHT;
					break;
					
				case Unit.RUN_RIGHT_DOWN:
					_currentAnimation = Unit.STAND_RIGHT_DOWN;
					break;
			}
		}
		
		public function playAttackAnimation():void
		{
			switch (_currentAnimation)
			{
				case Unit.STAND_DOWN:
					_currentAnimation = Unit.ATTACK_DOWN;
					break;
					
				case Unit.STAND_DOWN_LEFT:
					_currentAnimation = Unit.ATTACK_DOWN_LEFT;
					break;
					
				case Unit.STAND_LEFT: 
					_currentAnimation = Unit.ATTACK_LEFT;
					break;
					
				case Unit.STAND_LEFT_UP: 
					_currentAnimation = Unit.ATTACK_LEFT_UP;
					break;

				case Unit.STAND_UP:
					_currentAnimation = Unit.ATTACK_UP;
					break;
					
				case Unit.STAND_UP_RIGHT:
					_currentAnimation = Unit.ATTACK_UP_RIGHT;
					break;
					
				case Unit.STAND_RIGHT:
					_currentAnimation = Unit.ATTACK_RIGHT;
					break;
					
				case Unit.STAND_RIGHT_DOWN:
					_currentAnimation = Unit.ATTACK_RIGHT_DOWN;
					break;
			}
		}
		
		public function playJumpAnimation():void
		{
			switch (_currentAnimation)
			{
				case Unit.STAND_DOWN:
					_currentAnimation = Unit.JUMP_DOWN;
					break;
					
				case Unit.STAND_DOWN_LEFT:
					_currentAnimation = Unit.JUMP_DOWN_LEFT;
					break;
					
				case Unit.STAND_LEFT: 
					_currentAnimation = Unit.JUMP_LEFT;
					break;
					
				case Unit.STAND_LEFT_UP: 
					_currentAnimation = Unit.JUMP_LEFT_UP;
					break;

				case Unit.STAND_UP:
					_currentAnimation = Unit.JUMP_UP;
					break;
					
				case Unit.STAND_UP_RIGHT:
					_currentAnimation = Unit.JUMP_UP_RIGHT;
					break;
					
				case Unit.STAND_RIGHT:
					_currentAnimation = Unit.JUMP_RIGHT;
					break;
					
				case Unit.STAND_RIGHT_DOWN:
					_currentAnimation = Unit.JUMP_RIGHT_DOWN;
					break;
			}
		}
		
		private function animationCallback():void
		{
			switch (_currentAnimation)
			{
				case Unit.ATTACK_DOWN:
				case Unit.JUMP_DOWN:
					_currentAnimation = Unit.STAND_DOWN;
					break;
					
				case Unit.ATTACK_DOWN_LEFT:
				case Unit.JUMP_DOWN_LEFT:
					_currentAnimation = Unit.STAND_DOWN_LEFT;
					break;
					
				case Unit.ATTACK_LEFT:
				case Unit.JUMP_LEFT:
					_currentAnimation = Unit.STAND_LEFT;
					break;
					
				case Unit.ATTACK_LEFT_UP:
				case Unit.JUMP_LEFT_UP:
					_currentAnimation = Unit.STAND_LEFT_UP;
					break;

				case Unit.ATTACK_UP:
				case Unit.JUMP_UP:
					_currentAnimation = Unit.STAND_UP;
					break;
					
				case Unit.ATTACK_UP_RIGHT:
				case Unit.JUMP_UP_RIGHT:
					_currentAnimation = Unit.STAND_UP_RIGHT;
					break;
					
				case Unit.ATTACK_RIGHT:
				case Unit.JUMP_RIGHT:
					_currentAnimation = Unit.STAND_RIGHT;
					break;
					
				case Unit.ATTACK_RIGHT_DOWN:
				case Unit.JUMP_RIGHT_DOWN:
					_currentAnimation = Unit.STAND_RIGHT_DOWN;
					break;
			}
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
		
		private function walkTo(deltaX:Number, deltaY:Number):void
		{
			setCurrentAnimationBaseOnDirection(deltaX, deltaY);
			
			if (_isWalking != true)
			{
				_isWalking = true;
			}
		}
		
		private function walking():void
		{
			var remainX:int = _destX - this.x;
			var remainY:int = _destY - this.y;
			var remainLength:Number = Math.sqrt(remainX * remainX + remainY * remainY);
			if (remainLength > _walkingSpeed)
			{
				this.x += remainX / remainLength * _walkingSpeed;
				this.y += remainY / remainLength * _walkingSpeed;
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
			_terrain.setOccupied(unitPositionInIsometricSpace.x / _terrain.cellSize, unitPositionInIsometricSpace.z / _terrain.cellSize, true);
			stopRunning();
			_isWalking = false;
			_messageDispatcher.dispatchEvent(new UnitEvent(UnitEvent.STOP_MOVE));
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