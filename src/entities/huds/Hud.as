package entities.huds 
{
	import entities.bars.Bar;
	import entities.units.Unit;
	import flash.text.TextSnapshot;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Hud extends Entity 
	{
		private var _graphics:Graphiclist;
		
		private var _target:Unit;
		private var _picturesStrip:Image;
		private var _unitName:Text;
		private var _unitClass:Text;
		private var _lifeBar:Bar;
		private var _manaBar:Bar;
		private var _targetHpOverCurHp:Text;
		private var _targetMpOverCurMp:Text;
		private var _targetCurMp:Text;
		
		public function Hud() 
		{
			_picturesStrip = new Image(Assets.UNITS_PICTURE_STRIP);
			_picturesStrip.clipRect.width = 50;
			_picturesStrip.clipRect.height = 50;
			_picturesStrip.clipRect.y = 0;
			_picturesStrip.clear();
			_picturesStrip.updateBuffer();
			_picturesStrip.x = 10;
			_picturesStrip.y = 10;
			_picturesStrip.scrollX = _picturesStrip.scrollY = 0;
			
			_unitName = new Text("", 70, 10);
			_unitName.font = "Arial Font";
			_unitName.size = 14;
			_unitName.scrollX = _unitName.scrollY = 0;
			
			_unitClass = new Text("", 70, 25);
			_unitClass.font = "Arial Font";
			_unitClass.size = 12;
			_unitClass.scrollX = _unitClass.scrollY = 0;
			
			_lifeBar = new Bar(70, 45, 150, 6, 0xFF0000);
			_lifeBar.barImage.scrollX = _lifeBar.barImage.scrollY = 0;
			
			_targetHpOverCurHp = new Text("", 225, 40);
			_targetHpOverCurHp.font = "Arial Font";
			_targetHpOverCurHp.size = 10;
			_targetHpOverCurHp.scrollX = _targetHpOverCurHp.scrollY = 0;
			
			_manaBar = new Bar(70, 55, 150, 6, 0x0000FF);
			_manaBar.barImage.scrollX = _manaBar.barImage.scrollY = 0;
			
			_targetMpOverCurMp = new Text("", 225, 50);
			_targetMpOverCurMp.font = "Arial Font";
			_targetMpOverCurMp.size = 10;
			_targetMpOverCurMp.scrollX = _targetMpOverCurMp.scrollY = 0;
			
			_graphics = new Graphiclist(_picturesStrip, _unitName, _unitClass, _lifeBar.barImage, _targetHpOverCurHp, _manaBar.barImage, _targetMpOverCurMp);
			graphic = _graphics;
		}
		
		public function set target(value:Unit):void
		{
			_target = value;
			
			switch (_target.className)
			{
				case "Swordsman":
					_picturesStrip.clipRect.x = 0;
					break;
					
				case "Archer":
					_picturesStrip.clipRect.x = 50;
					break;
					
				case "Ninja":
					_picturesStrip.clipRect.x = 100;
					break;
					
				case "Dragon":
					_picturesStrip.clipRect.x = 150;
					break;
					
				case "Sorceror":
					_picturesStrip.clipRect.x = 200;
					break;
					
				case "Witch":
					_picturesStrip.clipRect.x = 250;
					break;
			}
			
			_picturesStrip.clear();
			_picturesStrip.updateBuffer();
			
			_unitName.text = "Name: " + _target.name;
			_unitClass.text = "Class: " + _target.className;
			
			_lifeBar.maxValue = _target.hp;
			_lifeBar.curValue = _target.curHp;
			_lifeBar.updateBar();
			
			_targetHpOverCurHp.text = _target.hp + "/" + _target.curHp;
			
			_manaBar.maxValue = _target.mp;
			_manaBar.curValue = _target.curMp;
			_manaBar.updateBar();
			
			_targetMpOverCurMp.text = _target.mp + "/" + _target.curMp;
		}
	}
}