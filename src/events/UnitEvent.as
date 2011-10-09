package events 
{
	import entities.units.Unit;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class UnitEvent extends Event 
	{
		public static const ATTRIBUTE_CHANGE:String = "unit_event_attribute_change";
		public static const START_MOVE:String 		= "unit_event_start_move";
		public static const STOP_MOVE:String 		= "unit_event_stop_move";
		public static const START_ATTACK:String 	= "unit_event_start_attack";
		public static const STOP_ATTACK:String		= "unit_event_stop_attack";
		
		public var unit:Unit;
		public var attributeName:String;
		
		public function UnitEvent(type:String, unit:Unit=null, attributeName:String="", bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			this.unit = unit;
			this.attributeName = attributeName;
		}
		
		public override function clone():Event {
			return new UnitEvent(type, unit, attributeName, bubbles, cancelable);
		}
	}
}