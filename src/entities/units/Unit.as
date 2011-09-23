package entities.units
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import utilities.builders.Terrain;
	import utilities.isometricprojection.IsoUtils;
	import utilities.isometricprojection.Point3D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	import com.hovotz.utilities.Node;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Unit extends Entity 
	{		
		public static const STAND_DOWN:String 		= "stand_down";
		public static const STAND_DOWN_LEFT:String 	= "stand_down_left";
		public static const STAND_LEFT:String 		= "stand_left";
		public static const STAND_LEFT_UP:String	= "stand_left_up";
		public static const STAND_UP:String			= "stand_up";
		public static const STAND_UP_RIGHT:String	= "stand_up_right";
		public static const STAND_RIGHT:String		= "stand_right";
		public static const STAND_RIGHT_DOWN:String = "stand_right_down";
		
		public static const RUN_DOWN:String			= "run_down";
		public static const RUN_DOWN_LEFT:String	= "run_down_left";
		public static const RUN_LEFT:String			= "run_left";
		public static const RUN_LEFT_UP:String		= "run_left_up";
		public static const RUN_UP:String			= "run_up";
		public static const RUN_UP_RIGHT:String		= "run_up_right";
		public static const RUN_RIGHT:String		= "run_right";
		public static const RUN_RIGHT_DOWN:String	= "run_right_down";
		
		private var _terrain:Terrain;
		
		private var _currentAnimation:String = Unit.STAND_DOWN;
		private var _path:Array;
		private var _isWalking:Boolean = false;
		private var _destX:int;
		private var _destY:int;
		private var _walkingSpeed:Number = 3;
		
		protected var _spritemap:Spritemap;
		protected var _spriteWidth:Number = 50;
		protected var _spriteHeight:Number = 50;
		
		public function Unit(source:*, position:Point) 
		{	
			_spritemap = new Spritemap(source, _spriteWidth, _spriteHeight);
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
			
			Input.define("walk_up", Key.W, Key.UP);
			Input.define("walk_left", Key.A, Key.LEFT);
			Input.define("walk_down", Key.S, Key.DOWN);
			Input.define("walk_right", Key.D, Key.RIGHT);
			
			//setHitbox(_spriteWidth, _spriteHeight, 10, 20);
			setHitbox(_spriteWidth, _spriteHeight, 25, 20);
		}
		
		public function setupSpritemap():void
		{
			_spritemap.add(Unit.RUN_DOWN, 			[24, 32, 40, 48], 9, true);
			_spritemap.add(Unit.RUN_DOWN_LEFT, 		[25, 33, 41, 49], 9, true);
			_spritemap.add(Unit.RUN_LEFT, 			[26, 34, 42, 50], 9, true);
			_spritemap.add(Unit.RUN_LEFT_UP, 		[27, 35, 43, 51], 9, true);
			_spritemap.add(Unit.RUN_UP, 			[28, 36, 44, 52], 9, true);
			_spritemap.add(Unit.RUN_UP_RIGHT,		[29, 37, 45, 53], 9, true);
			_spritemap.add(Unit.RUN_RIGHT, 			[30, 38, 46, 54], 9, true);
			_spritemap.add(Unit.RUN_RIGHT_DOWN,		[31, 39, 47, 55], 9, true);
			_spritemap.add(Unit.STAND_DOWN, 		[16], 0, false);
			_spritemap.add(Unit.STAND_DOWN_LEFT, 	[17], 0, false);
			_spritemap.add(Unit.STAND_LEFT, 		[18], 0, false);
			_spritemap.add(Unit.STAND_LEFT_UP,		[19], 0, false);
			_spritemap.add(Unit.STAND_UP, 			[20], 0, false);
			_spritemap.add(Unit.STAND_UP_RIGHT,		[21], 0, false);
			_spritemap.add(Unit.STAND_RIGHT, 		[22], 0, false);
			_spritemap.add(Unit.STAND_RIGHT_DOWN,	[23], 0, false);
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
		}
		
		public function inFocusUpdate():void
		{
			var horizontalMovement:Boolean = true;
			var verticalMovement:Boolean = true;
			
			_spritemap.play(_currentAnimation);
			
			if (Input.check("walk_left"))
			{
				if (!colliding(new Point(x - _walkingSpeed, y)))
				{
					x -= _walkingSpeed;
					_currentAnimation = "walk_left";	
				}
			}
			else if (Input.check("walk_right"))
			{
				if (!colliding(new Point(x + _walkingSpeed, y)))
				{
					x += _walkingSpeed;
					_currentAnimation = "walk_right";	
				}
			}
			else horizontalMovement = false;
			
			if (Input.check("walk_up"))
			{
				if (!colliding(new Point(x, y - _walkingSpeed)))
				{
					y -= _walkingSpeed;
					_currentAnimation = "walk_up";	
				}
			}
			else if (Input.check("walk_down"))
			{
				if (!colliding(new Point(x, y + _walkingSpeed)))
				{
					y += _walkingSpeed;
					_currentAnimation = "walk_down";	
				}
			}
			else verticalMovement = false;
			
			if ((!verticalMovement) && (!horizontalMovement))
			{
				switch (_currentAnimation)
				{
					case "walk_left": 
						_currentAnimation = "stand_left"; 
						break;
						
					case "walk_right":
						_currentAnimation = "stand_right";
						break;
						
					case "walk_up":
						_currentAnimation = "stand_up";
						break;
						
					case "walk_down":
						_currentAnimation = "stand_down";
				}
			}
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
		
		public function colliding(position:Point):Boolean
		{
			if (collide("solid", position.x, position.y)) return true;
			else if (collide("house", position.x, position.y)) return true;
			else return false;
		}
	}
}