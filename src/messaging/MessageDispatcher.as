package messaging 
{
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class MessageDispatcher extends EventDispatcher 
	{
		private static var instance:MessageDispatcher;
		
		public function MessageDispatcher(key:SingletonEnforcer, target:IEventDispatcher=null) 
		{
			super(target);
			if (key == null) {
				throw new Error("Error: Instantiation failed: Use MessageDispatcher.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():MessageDispatcher {
			if (instance == null) {
				instance = new MessageDispatcher(new SingletonEnforcer());
			}
			return instance;
		}
	}
}

internal class SingletonEnforcer {
}