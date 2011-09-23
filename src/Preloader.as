package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	
	public class Preloader extends MovieClip 
	{		
		private var square:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		private var wd:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240;
		private var text:TextField = new TextField();
		
		public function Preloader() 
		{
			stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			addChild(square);
			square.x = 200;
			square.y = stage.stageHeight / 2;
			
			addChild(border);
			border.x = 200-4;
			border.y = stage.stageHeight / 2 - 4;
		
			addChild(text);
			text.x = 194;
			text.y = stage.stageHeight / 2 - 30;
			
			// TODO show loader
		}
		
		private function onEnterFrame(e:Event):void 
		{
			graphics.clear();
			if(framesLoaded == totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				nextFrame();
				init();
			}
			else
			{
				var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				
				square.graphics.beginFill(0x000000);
				square.graphics.drawRect(0,0,(loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240,20);
				square.graphics.endFill();
				
				border.graphics.lineStyle(2,0x000000);
				border.graphics.drawRect(0, 0, 248, 28);
				
				text.textColor = 0x000000;
				text.text = "Loading: " + Math.ceil((loaderInfo.bytesLoaded/loaderInfo.bytesTotal)*100) + "%";
			}
		}
		
		private function init():void
		{
			var mainClass:Class = Class(getDefinitionByName("Main"));
			if(mainClass)
			{
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	}	
}