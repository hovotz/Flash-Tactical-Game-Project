package events 
{
	import flash.events.Event;
	import graph.Node;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class SelectorEvent extends Event 
	{
		public static const SELECTOR_ROLLOVER:String	= "selector_event_selector_rollover";
		public static const SELECTOR_CLICK:String		= "selector_event_selector_click";
		
		public var cellState:String;
		public var node:Node;
		
		public function SelectorEvent(type:String, cellState:String, node:Node=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			this.cellState = cellState;
			this.node = node;
		}
		
		public override function clone():Event {
			return new SelectorEvent(type, cellState, node, bubbles, cancelable);
		}
	}
}