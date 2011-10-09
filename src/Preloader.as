package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Preloader extends MovieClip 
	{
		private var _backgroundBitmapData:BitmapData;
		private var _backgroundBitmap:Bitmap;
		private var _bar:Sprite = new Sprite();
		private var _border:Sprite = new Sprite();
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			_backgroundBitmapData = new BitmapData(640, 480, false, 0x000000);
			_backgroundBitmap = new Bitmap(_backgroundBitmapData);
			addChild(_backgroundBitmap);
			
			_border.x = 268;
			_border.y = 235;
			_border.graphics.lineStyle(2,0xFFFFFF);
			_border.graphics.drawRect(0, 0, 104, 10);
			addChild(_border)
			
			_bar.x = 270;
			_bar.y = 237;
			addChild(_bar);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var percent:int = e.bytesLoaded / e.bytesTotal * 100;
			
			_bar.graphics.clear();
			_bar.graphics.beginFill(0xFFFFFF);
			_bar.graphics.drawRect(0, 0, percent, 6);
			_bar.graphics.endFill();
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}	
	}	
}