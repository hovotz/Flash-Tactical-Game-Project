package entities 
{
	import graph.Node;
	import messaging.MessageDispatcher;
	import events.SelectorEvent;
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
		public static const OCCUPIED:String 	= "occupied";
		public static const HIGHLIGHTED:String 	= "highlighted";
		public static const EMPTY:String		= "empty";
		
		private var _world:World;
		private var _terrain:Terrain;
		private var _messageDispatcher:MessageDispatcher;
		
		private var _cellState:String;
		
		private var _occupiedCellImage:Image 	= new Image(Assets.ISO_SELECTOR_GREEN);
		private var _highlightedCellImage:Image = new Image(Assets.ISO_SELECTOR_WHITE);
		private var _emptyCellImage:Image 		= new Image(Assets.ISO_SELECTOR_RED);
		
		private var _mouseIS:Point3D; 	// Mouse Isometric Space
		private var _ISX:int;			// Selector Isometric Space X
		private var _ISY:int;			// Selector Isometric Space Y
		private var _ISCol:int;			// Selector Isometric Space Col
		private var _ISRow:int;			// Selector Isometric Space Row
		private var _SS:Point;			// Selector Screen Space
		private var _moved:Boolean = false;
		
		public function get ISCol():int
		{
			return _ISCol;
		}
		
		public function get ISRow():int
		{
			return _ISRow;
		}
		
		public function get SSX():int
		{
			return _SS.x;
		}
		
		public function get SSY():int
		{
			return _SS.y;
		}
		
		public function Selector(world:World, terrain:Terrain) 
		{
			_world = world;
			_terrain = terrain;
			_messageDispatcher = MessageDispatcher.getInstance();
			
			_occupiedCellImage.originX = 30;
			_occupiedCellImage.originY = 0;
			_highlightedCellImage.originX = 30;
			_highlightedCellImage.originY = 0;
			_emptyCellImage.originX = 30;
			_emptyCellImage.originY = 0;
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
		
		private function changeImage():void
		{
			switch (_cellState)
			{
				case Selector.OCCUPIED:
					graphic = _occupiedCellImage;
					break;
					
				case Selector.HIGHLIGHTED:
					graphic = _highlightedCellImage;
					break;
					
				case Selector.EMPTY:
					graphic = _emptyCellImage;
					break;
			}
		}
		
		override public function update():void
		{
			_mouseIS = IsoUtils.screenToIso(new Point(Input.mouseX + _world.camera.x, Input.mouseY + _world.camera.y));
			
			var ISCol:int = (_mouseIS.x / _terrain.cellSize);
			var ISRow:int = (_mouseIS.z / _terrain.cellSize);
			if (_ISCol !=  ISCol|| _ISRow != ISRow)
			{
				_ISCol = ISCol;
				_ISRow = ISRow;
				_moved = true;
			}	
			
			_ISX = _ISCol * _terrain.cellSize;
			_ISY = _ISRow * _terrain.cellSize;
			
			if (_ISX < 0 || 
				_ISX >= (_terrain.cols * _terrain.cellSize) ||
				_ISY < 0 ||
				_ISY >= (_terrain.rows * _terrain.cellSize)) 
			{
				if (visible)
				{
					visible = false;
				}
			}
			else 
			{
				if (!visible)
				{
					visible = true;
				}
				
				var node:Node = _terrain.getNode(_ISCol, _ISRow);
				
				if (node.occupied)
				{
					_cellState = Selector.OCCUPIED;
				}
				else if (node.highlighted)
				{
					_cellState = Selector.HIGHLIGHTED;
				}
				else
				{
					_cellState = Selector.EMPTY;
				}
				
				changeImage();
				
				if (_moved)
				{
					_messageDispatcher.dispatchEvent(new SelectorEvent(SelectorEvent.SELECTOR_ROLLOVER, _cellState, node));
					_moved = false;
				}
				
				if (Input.mousePressed)
				{
					_messageDispatcher.dispatchEvent(new SelectorEvent(SelectorEvent.SELECTOR_CLICK, _cellState, node));
				}
				
				_SS = IsoUtils.isoToScreen(new Point3D(_ISX, 0, _ISY));
				x = _SS.x;
				y = _SS.y;
			}
		}
	}
}