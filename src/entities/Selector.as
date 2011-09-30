package entities 
{
	import flash.geom.Point;
	import net.flashpunk.World;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	import builders.Terrain;
	
	import graph.Grid;
	
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Selector extends Entity
	{
		private var _world:World;
		private var _terrain:Terrain;
		
		private var _unwalkableImage:Image = new Image(Assets.ISO_SELECTOR_RED);
		private var _walkableImage:Image = new Image(Assets.ISO_SELECTOR_WHITE);
		private var _occupiedImage:Image = new Image(Assets.ISO_SELECTOR_GREEN);
		
		private var _mouseIS:Point3D; 	// Mouse Isometric Space
		private var _ISX:int;			// Selector Isometric Space X
		private var _ISY:int;			// Selector Isometric Space Y
		private var _ISCol:int;			// Selector Isometric Space Col
		private var _ISRow:int;			// Selector Isometric Space Row
		private var _SS:Point;			// Selector Screen Space
		
		public function get ISCol():int
		{
			return _ISCol;
		}
		
		public function get ISRow():int
		{
			return _ISRow;
		}
		
		public function Selector(world:World, terrain:Terrain) 
		{
			_world = world;
			_terrain = terrain;
			
			_unwalkableImage.originX = 30;
			_unwalkableImage.originY = 0;
			
			_walkableImage.originX = 30;
			_walkableImage.originY = 0;
			
			_occupiedImage.originX = 30;
			_occupiedImage.originY = 0;
		}
		
		public function show():void
		{
			active = true;
			if (graphic)
			{
				graphic.visible = true;
			}
		}
		
		public function hide():void
		{
			active = false;
			if (graphic)
			{
				graphic.visible = false;
			}
		}
		
		public function cellIsWalakble():void
		{
			graphic = _walkableImage;
		}
		
		public function cellIsUnwalkable():void
		{
			graphic = _unwalkableImage;
		}
		
		public function cellIsOccupied():void
		{
			graphic = _occupiedImage;
		}
		
		override public function update():void
		{
			_mouseIS = IsoUtils.screenToIso(new Point(Input.mouseX + _world.camera.x, Input.mouseY + _world.camera.y));
			
			_ISCol = (_mouseIS.x / _terrain.cellSize);
			_ISRow = (_mouseIS.z / _terrain.cellSize);
			_ISX = _ISCol * _terrain.cellSize;
			_ISY = _ISRow * _terrain.cellSize;
			
			if (_ISX < 0 || 
				_ISX >= (_terrain.cols * _terrain.cellSize) ||
				_ISY < 0 ||
				_ISY >= (_terrain.rows * _terrain.cellSize)) 
			{
				visible = false;
			}
			else 
			{	
				visible = true;
				
				if (_terrain.isHighlighted(_ISCol, _ISRow))
				{
					cellIsWalakble();
				}
				else
				{
					cellIsUnwalkable();
				}
				
				_SS = IsoUtils.isoToScreen(new Point3D(_ISX, 0, _ISY));
				x = _SS.x;
				y = _SS.y;
			}
		}
	}
}