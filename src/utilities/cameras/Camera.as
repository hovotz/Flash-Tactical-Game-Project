package utilities.cameras
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Camera 
	{
		private var _world:World;
		private var _boundary:Rectangle;
		private var _target:Entity;
		
		public function set target(value:Entity):void
		{
			_target = value;
		}
		
		public function Camera(world:World, boundary:Rectangle, target:Entity) 
		{
			_world = world;
			_boundary = boundary;
			_target = target;
		}
		
		public function focusTarget():void
		{
			//_world.camera.x = _target.x - (FP.halfWidth - (_target.width / 2));
			_world.camera.x = _target.left - (FP.halfWidth - _target.halfWidth);
			if (_world.camera.x < _boundary.left)
			{
				_world.camera.x = _boundary.left;
			}
			else if (_world.camera.x > _boundary.right - FP.width)
			{
				_world.camera.x = _boundary.right - FP.width;
			}
			
			//_world.camera.y = _target.y - (FP.halfHeight - (_target.height / 2));
			_world.camera.y = _target.top - (FP.halfHeight - _target.halfHeight);
			if (_world.camera.y < _boundary.top)
			{
				_world.camera.y = _boundary.top;
			}
			else if (_world.camera.y > _boundary.bottom - FP.height)
			{
				_world.camera.y = _boundary.bottom - FP.height;
			}
		}
		
		public function followTarget():void
		{
			if (_target.left > FP.halfWidth && (_target.left + _target.width) <  _boundary.right - FP.halfWidth)
			{
				_world.camera.x = _target.left - (FP.halfWidth - _target.halfWidth);
			}
			if (_target.top > FP.halfHeight && (_target.top + _target.height) <  _boundary.bottom - FP.halfHeight)
			{
				_world.camera.y = _target.top  - (FP.halfHeight - _target.halfHeight);
			}
		}
		
		public function update():void
		{
			if (Input.check(Key.LEFT) && _world.camera.x >= _boundary.left)
			{
				_world.camera.x -= 10;
			}
			
			if (Input.check(Key.RIGHT) && (_world.camera.x + FP.width) <= _boundary.right)
			{
				_world.camera.x += 10;
			}
			
			if (Input.check(Key.UP) && _world.camera.y >= _boundary.top)
			{
				_world.camera.y -= 10;
			}
			
			if (Input.check(Key.DOWN) && (_world.camera.y + FP.height) <= _boundary.bottom)
			{
				_world.camera.y += 10;
			}
		}
	}
}