package entities.huds 
{
	import entities.units.Unit;
	import events.UnitEvent;
	import messaging.MessageDispatcher;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import net.flashpunk.utils.Draw;
	
	import entities.Bar;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class UnitInfoView 
	{
		public static const LEFT_ARRANGEMENT:String 	= "left_arrangement";
		public static const RIGHT_ARRANGEMENT:String 	= "right_arrangement";
		
		private var _messageDispatcher:MessageDispatcher;
		
		private var _arrangement:String;
		
		private var _data:Unit;
		private var _graphics:Graphiclist;
		private var _x:int;
		private var _y:int;
		private var _label:Text;
		private var _picture:Image;
		private var _name:Text;
		private var _class:Text;
		private var _hpBar:Bar;
		private var _mpBar:Bar;
		private var _hpText:Text;
		private var _mpText:Text;
		
		public function show():void
		{
			_graphics.visible = true;
		}
		
		public function hide():void
		{
			_graphics.visible = false;
		}
		
		public function UnitInfoView(arrangement:String) 
		{	
			_messageDispatcher = MessageDispatcher.getInstance();
			switch(arrangement)
			{
				case UnitInfoView.LEFT_ARRANGEMENT:
					Text.align = "left";
					break;
					
				case UnitInfoView.RIGHT_ARRANGEMENT:
					Text.align = "right";
					break;
			}
			_arrangement = arrangement;
			init();
		}
		
		public function init():void
		{
			_picture = Image.createRect(50, 50, 0, 0);
			_picture.scrollX = 0;
			_picture.scrollY = 0;
			
			_name = new Text("");
			_name.size = 14;
			_name.scrollX = 0;
			_name.scrollY = 0;
			
			_class = new Text("");
			_class.size = 12;
			_class.scrollX = 0;
			_class.scrollY = 0;
			
			_hpBar = new Bar(0, 0, 150, 7, 0xFF0000);
			_hpBar.scrollX = 0;
			_hpBar.scrollY = 0;
			if (_arrangement == UnitInfoView.RIGHT_ARRANGEMENT)
			{
				_hpBar.alignment = Bar.RIGHT_ALIGNMENT;
			}
			
			_hpText = new Text("");
			_hpText.size = 10;
			_hpText.scrollX = 0;
			_hpText.scrollY = 0;
						
			_mpBar = new Bar(0, 0, 150, 7, 0x0000FF);
			_mpBar.scrollX = 0;
			_mpBar.scrollY = 0;
			if (_arrangement == UnitInfoView.RIGHT_ARRANGEMENT)
			{
				_mpBar.alignment = Bar.RIGHT_ALIGNMENT;
			}
			
			_mpText = new Text("");
			_mpText.size = 10;
			_mpText.scrollX = 0;
			_mpText.scrollY = 0;
			
			_label = new Text("");
			_label.size = 10;
			_label.scrollX = 0;
			_label.scrollY = 0;
			
			_graphics = new Graphiclist(_picture, _name, _class, _hpBar.graphics, _hpText, _mpBar.graphics, _mpText, _label);
			
			_messageDispatcher.addEventListener(UnitEvent.ATTRIBUTE_CHANGE, onAttributeChangeEvent);
		}
		
		private function onAttributeChangeEvent(ue:UnitEvent):void
		{
			if (_data != null && ue.unit != null && _data.getId == ue.unit.getId)
			{
				updateDynamicAttributes();
				_hpBar.updateBar();
				_mpBar.updateBar();
			}
		}
		
		public function arrange():void
		{
			switch(_arrangement)
			{
				case UnitInfoView.LEFT_ARRANGEMENT:
					_picture.x = _x + 0;
					_picture.y = _y + 0;
					
					_name.x = _x + 60;
					_name.y = _y + 0;
					
					_class.x = _x + 60;
					_class.y = _y + 15;
	
					_hpBar.x = _x + 60;
					_hpBar.y = _y + 32;
				
					_hpText.x = _x + 215;
					_hpText.y = _y + 28;
				
					_mpBar.x = _x + 60;
					_mpBar.y = _y + 42;
					
					_mpText.x = _x + 215;
					_mpText.y = _y + 38;
					
					_label.x = _x + 10;
					_label.y = _y + 53;
					
					break;
					
				case UnitInfoView.RIGHT_ARRANGEMENT:
					_picture.x = _x - (0 + _picture.width);
					_picture.y = _y + 0;
					
					_name.x = _x - (60 + _name.width);
					_name.y = _y + 0;
					
					_class.x = _x - (60 + _class.width);
					_class.y = _y + 15;
	
					_hpBar.x = _x - (60 + _hpBar.width);
					_hpBar.y = _y + 32;
				
					_hpText.x = _x - (215 + _hpText.width);
					_hpText.y = _y + 28;
				
					_mpBar.x = _x - (60 + _mpBar.width);
					_mpBar.y = _y + 42;
					
					_mpText.x = _x - (215 + _mpText.width);
					_mpText.y = _y + 38;
					
					_label.x = _x - (10 + _label.width);
					_label.y = _y + 53;
					
					break;
			}
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		public function set label(value:String):void
		{
			_label.text = value;
		}
		
		public function set data(value:Unit):void
		{
			_data = value;
			
			if (_data != null)
			{
				updateStaticAttributes();
				updateDynamicAttributes();
				arrange();
				_hpBar.updateBar();
				_mpBar.updateBar();
				show();
			}
			else
			{
				hide();
			}
		}
		
		private function updateStaticAttributes():void
		{
			_picture.buffer.copyPixels(_data.picture.buffer, new Rectangle(0, 0, 50, 50), new Point(0, 0));
			_name.text = "Name: " + _data.name;
			_class.text = "Class: " + _data.className;
		}
		
		private function updateDynamicAttributes():void
		{
			_hpBar.maxValue = _data.maxHp;
			_hpBar.curValue = _data.hp;
			_hpText.text 	= _data.hp + "/" + _data.maxHp;
			_mpBar.maxValue = _data.maxMp;
			_mpBar.curValue = _data.mp;
			_mpText.text 	= _data.mp + "/" + _data.maxMp;
		}
		
		public function get graphics():Graphiclist
		{
			return _graphics;
		}
	}
}