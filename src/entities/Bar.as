package entities 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Bar
	{
		public static const	LEFT_ALIGNMENT:String = "left_alignment";
		public static const RIGHT_ALIGNMENT:String = "right_alignment";
		
		private var _alignment:String = Bar.LEFT_ALIGNMENT;
		private var _bounds:Rectangle;
		private var _graphics:Graphiclist;
		private var _borderImage:Image;
		private var _barImage:Image;
		private var _maxValue:int;
		private var _curValue:int;
		private var _width:int;
		private var _height:int;
		private var _innerX:int;
		private var _innerY:int;
		private var _innerWidth:int;
		private var _innerHeight:int;
		
		public function Bar(x:int, y:int, width:int, height:int, color:uint)
		{
			_bounds = new Rectangle(x, y, width, height);
			_width = width;
			_height = height;
			_innerX = x + 2;
			_innerY = y + 2;
			_innerWidth = _width - 4;
			_innerHeight = _height - 4;
			FP.sprite.graphics.clear();
			FP.sprite.graphics.lineStyle(1, color);
			FP.sprite.graphics.drawRect(0, 0, width - 1, height - 1);
			var data:BitmapData = new BitmapData(width, height, true, 0);
			data.draw(FP.sprite);
			_borderImage = new Image(data);
			_borderImage.x = x;
			_borderImage.y = y;
			_barImage = Image.createRect(_innerWidth, _innerHeight, color);
			_barImage.x = _innerX; 
			_barImage.y = _innerY;
			_graphics = new Graphiclist(_borderImage, _barImage);
		}
		
		public function set alignment(value:String):void
		{
			_alignment = value;
		}
		
		public function updateBar():void
		{
			var rectWidth:int = (_curValue / _maxValue) * _innerWidth;
			rectWidth = rectWidth < 0 		? 0			: rectWidth;
			rectWidth = rectWidth > _width 	? _width 	: rectWidth;
			_barImage.clipRect.width = rectWidth;
			
			if (_alignment == Bar.LEFT_ALIGNMENT)
			{
				_barImage.clipRect.x = 0;
				_barImage.x = _innerX;
			} 
			else 
			{
				_barImage.clipRect.x = _innerWidth - _barImage.clipRect.width;
				_barImage.x = _innerX + _barImage.clipRect.x;
			}
	
			_barImage.clear();
			_barImage.updateBuffer();
		}
		
		public function get graphics():Graphiclist
		{
			return _graphics;
		}
		
		public function get bounds():Rectangle
		{
			return _bounds;
		}
		
		public function set x(value:int):void
		{
			_borderImage.x = value;
			_innerX = value + 2;
			if (_alignment == Bar.LEFT_ALIGNMENT)
			{
				_barImage.x = _innerX + _barImage.clipRect.x;
			}
			else
			{
				_barImage.x = _innerX;
			}
		}
		
		public function set y(value:int):void
		{
			_borderImage.y = value;
			_barImage.y = value + 2;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function set maxValue(value:int):void
		{
			_maxValue = value;
		}
		
		public function set curValue(value:int):void
		{
			_curValue = value;
		}
		
		public function set scrollX(value:int):void
		{
			_borderImage.scrollX = value;
			_barImage.scrollX = value;
		}
		
		public function set scrollY(value:int):void
		{
			_borderImage.scrollY = value;
			_barImage.scrollY = value;
		}
	}
}