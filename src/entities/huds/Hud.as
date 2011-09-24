package entities.huds 
{
	import entities.bars.Bar;
	import entities.units.Unit;
	import flash.text.TextSnapshot;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Hud extends Entity 
	{
		private var _graphics:Graphiclist;
		
		private var _target:Unit;
		private var _unitName:Text;
		private var _unitClass:Text;
		private var _lifeBar:Bar;
		private var _manaBar:Bar;
		private var _targetHpOverCurHp:Text;
		private var _targetMpOverCurMp:Text;
		private var _targetCurMp:Text;
		
		public function Hud() 
		{
			_unitName = new Text("", 10, 10);
			_unitName.font = "Arial Font";
			_unitName.size = 14;
			_unitName.scrollX = _unitName.scrollY = 0;
			
			_unitClass = new Text("", 10, 25);
			_unitClass.font = "Arial Font";
			_unitClass.size = 12;
			_unitClass.scrollX = _unitClass.scrollY = 0;
			
			_lifeBar = new Bar(10, 45, 150, 6, 0xFF0000);
			_lifeBar.barImage.scrollX = _lifeBar.barImage.scrollY = 0;
			
			_targetHpOverCurHp = new Text("", 165, 40);
			_targetHpOverCurHp.font = "Arial Font";
			_targetHpOverCurHp.size = 10;
			_targetHpOverCurHp.scrollX = _targetHpOverCurHp.scrollY = 0;
			
			_manaBar = new Bar(10, 55, 150, 6, 0x0000FF);
			_manaBar.barImage.scrollX = _manaBar.barImage.scrollY = 0;
			
			_targetMpOverCurMp = new Text("", 165, 50);
			_targetMpOverCurMp.font = "Arial Font";
			_targetMpOverCurMp.size = 10;
			_targetMpOverCurMp.scrollX = _targetMpOverCurMp.scrollY = 0;
			
			_graphics = new Graphiclist(_unitName, _unitClass, _lifeBar.barImage, _targetHpOverCurHp, _manaBar.barImage, _targetMpOverCurMp);
			graphic = _graphics;
		}
		
		public function set target(value:Unit):void
		{
			_target = value;
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