package entities 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class GameEntity extends Entity 
	{
		private static var _nextValidId:int;
		
		private var _id:int;
		
		public function GameEntity(id:int) 
		{	
			setId(id);
		}
		
		private function setId(value:int):void
		{
			_id = value;
			_nextValidId = _id + 1;
		}
		
		public function getId():int
		{
			return _id;
		}
	}
}