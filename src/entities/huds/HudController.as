package entities.huds 
{	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	import entities.units.Unit;
	import entities.Bar;
		
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class HudController extends Entity 
	{
		private var _graphics:Graphiclist;
		
		private var _activeUnit:Unit;
		private var _targetUnit:Unit;
		
		private var _activeUnitInfoView:UnitInfoView;
		private var _targetUnitInfoView:UnitInfoView;
		
		public function HudController() 
		{
			_activeUnitInfoView = new UnitInfoView(UnitInfoView.LEFT_ARRANGEMENT);
			_activeUnitInfoView.x = 10;
			_activeUnitInfoView.y = 10;
			_activeUnitInfoView.label = "Active";
			_activeUnitInfoView.hide();
			
			_targetUnitInfoView = new UnitInfoView(UnitInfoView.RIGHT_ARRANGEMENT);
			_targetUnitInfoView.x = 630;
			_targetUnitInfoView.y = 10;
			_targetUnitInfoView.label = "Target";
			_targetUnitInfoView.hide();
			
			_graphics = new Graphiclist(_activeUnitInfoView.graphics, _targetUnitInfoView.graphics);
			graphic = _graphics;
		}
		
		public function setActiveUnit(value:Unit):void
		{
			_activeUnitInfoView.show();
			_activeUnit = value;
			_activeUnitInfoView.data = value;
		}
		
		public function setTargetUnit(value:Unit):void
		{
			if (value != null && value.getId() == _activeUnit.getId())
			{
				_targetUnit = null;
				_targetUnitInfoView.data = null;
			}
			else
			{
				_targetUnitInfoView.show();
				_targetUnit = value;
				_targetUnitInfoView.data = value;	
			}
		}
	}
}