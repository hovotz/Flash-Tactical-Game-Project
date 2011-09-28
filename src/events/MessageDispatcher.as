package events 
{
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class MessageDispatcher extends EventDispatcher 
	{
		public function MessageDispatcher(target:IEventDispatcher=null) 
		{
			super(target);
		}	
	}
}