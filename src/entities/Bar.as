package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Bar
	{
		private var _barImage:Image;
		
		private var _maxValue:int;
		private var _curValue:int;
		
		private var _width:int;
		private var _height:int;
		
		public function Bar(x:int, y:int, width:int, height:int, color:uint)
		{
			_width = width;
			_height = height;
			
			_barImage = Image.createRect(_width, _height, color);
			_barImage.x = x;
			_barImage.y = y;
		}
		
		public function updateBar():void
		{
			var rectWidth:int = (_curValue / _maxValue) * _width;
			rectWidth = rectWidth < 0 		? 0			: rectWidth;
			rectWidth = rectWidth > _width 	? _width 	: rectWidth;
			_barImage.clipRect.width = rectWidth;
			_barImage.clear();
			_barImage.updateBuffer();
		}
		
		public function get barImage():Image
		{
			return _barImage;
		}
		
		public function set maxValue(value:int):void
		{
			_maxValue = value;
		}
		
		public function set curValue(value:int):void
		{
			_curValue = value;
		}
	}
}