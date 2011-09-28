package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class UnitEvent extends Event 
	{
		public static const STOP_MOVE:String = "unit_event_stop_move";
		
		public function UnitEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}	
	}
}