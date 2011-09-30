package graph 
{
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Node 
	{
		public var tileDataId:uint;
		public var col:int;
		public var row:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = true;
		public var occupied:Boolean = false;
		public var highlighted:Boolean = false;
		public var parent:Node;
		public var costMultiplier:Number = 1.0;
		
		public function Node(col:int, row:int) 
		{
			this.col = col;
			this.row = row;
		}	
	}
}