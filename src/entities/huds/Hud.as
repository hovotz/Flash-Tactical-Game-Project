package entities.huds 
{
	import entities.units.Unit;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Hud extends Entity 
	{
		private var _target:Unit;
		private var _unitClass:Text;
		
		
		public function Hud() 
		{
			_unitClass = new Text("");
			_unitClass.font = "Arial Font";
			_unitClass.scrollX = 0;
			_unitClass.scrollY = 0;
			graphic = _unitClass;
		}
		
		public function set target(value:Unit):void
		{
			_target = value;
			_unitClass.text = _target.className;
		}
	}
}