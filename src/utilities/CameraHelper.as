package utilities
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import builders.Terrain;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class CameraHelper
	{
		private var _world:World;
		private var _terrain:Terrain;
		private var _camera:Point;
		private var _target:Entity;
		
		private var _isMoveCameraByArrowKeysActive:Boolean = true;
		private var _isMoveCameraByMouseDragActive:Boolean = true;
		
		private var _oldMouseX:int;
		private var _oldMouseY:int;
		
		public function set target(value:Entity):void
		{
			_target = value;
		}
		
		public function set isMoveCameraByArrowKeysActive(value:Boolean):void
		{
			_isMoveCameraByArrowKeysActive = value;
		}
		
		public function get isMoveCameraByArrowKeysActive():Boolean
		{
			return _isMoveCameraByArrowKeysActive;
		}
		
		public function set isMoveCameraByMouseDragActive(value:Boolean):void
		{
			_isMoveCameraByMouseDragActive = value;
		}
		
		public function get isMoveCameraByMouseDragActive():Boolean
		{
			return _isMoveCameraByMouseDragActive;
		}
		
		public function CameraHelper(world:World, terrain:Terrain, target:Entity) 
		{
			_world = world;
			_terrain = terrain;
			_camera = world.camera;
			_target = target;
		}
		
		public function focusTarget():void
		{
			_camera.x = _target.left - (FP.halfWidth - _target.halfWidth);
			if (_camera.x < _terrain.bounds.left)
			{
				_camera.x = _terrain.bounds.left;
			}
			else if (_camera.x > _terrain.bounds.right - FP.width)
			{
				_camera.x = _terrain.bounds.right - FP.width;
			}
			
			_camera.y = _target.top - (FP.halfHeight - _target.halfHeight);
			if (_camera.y < _terrain.bounds.top)
			{
				_camera.y = _terrain.bounds.top;
			}
			else if (_camera.y > _terrain.bounds.bottom - FP.height)
			{
				_camera.y = _terrain.bounds.bottom - FP.height;
			}
		}
		
		public function followTarget():void
		{
			if (_target.left > (_terrain.bounds.left + FP.halfWidth) && 
			   (_target.left + _target.width) <  _terrain.bounds.right - FP.halfWidth)
			{
				_camera.x = _target.left - (FP.halfWidth - _target.halfWidth);
			}
			
			if (_target.top > (_terrain.bounds.top + FP.halfHeight) && 
			   (_target.top + _target.height) <  _terrain.bounds.bottom - FP.halfHeight)
			{
				_camera.y = _target.top  - (FP.halfHeight - _target.halfHeight);
			}
		}
		
		public function update():void
		{
			if (_isMoveCameraByArrowKeysActive)
				moveCameraByArrowKeysUpdate();
			
			if (_isMoveCameraByMouseDragActive)
				moveCameraByMouseDragUpdate();
		}
		
		private function moveCameraByArrowKeysUpdate():void
		{
			if (Input.check(Key.LEFT)) {
				_camera.x -= 10;
				_camera.x = (_camera.x < _terrain.bounds.left) ? _terrain.bounds.left : _camera.x;
			}
			
			if (Input.check(Key.RIGHT)) {
				_camera.x += 10;
				_camera.x = (_camera.x > (_terrain.bounds.right - FP.width)) ? (_terrain.bounds.right - FP.width) : _camera.x;
			}
			
			if (Input.check(Key.UP)) {
				_camera.y -= 10;
				_camera.y = (_camera.y < _terrain.bounds.top) ? _terrain.bounds.top : _camera.y;
			}
			
			if (Input.check(Key.DOWN)) {
				_camera.y += 10;
				_camera.y = (_camera.y > (_terrain.bounds.bottom - FP.height)) ? (_terrain.bounds.bottom - FP.height) : _camera.y;
			}
		}
		
		private function moveCameraByMouseDragUpdate():void
		{
			if (Input.mousePressed)
			{
				_oldMouseX = Input.mouseX;
				_oldMouseY = Input.mouseY;
			}
			
			if (Input.mouseDown)
			{
				_camera.x += _oldMouseX - Input.mouseX;
				_camera.y += _oldMouseY - Input.mouseY;
				_camera.x = (_camera.x < _terrain.bounds.left) ? _terrain.bounds.left : _camera.x;
				_camera.x = (_camera.x > (_terrain.bounds.right - FP.width)) ? (_terrain.bounds.right - FP.width) : _camera.x;
				_camera.y = (_camera.y < 0) ? 0 : _camera.y;
				_camera.y = (_camera.y > (_terrain.bounds.bottom - FP.height)) ? (_terrain.bounds.bottom - FP.height) : _camera.y;
				
				_oldMouseX = Input.mouseX;
				_oldMouseY = Input.mouseY;
			}
		}
	}
}