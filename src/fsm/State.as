package fsm 
{
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public interface State 
	{
		function enter(agent:*):void;
		function update(agent:*):void;
		function exit(agent:*):void;
	}	
}