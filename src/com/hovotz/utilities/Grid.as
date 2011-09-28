package com.hovotz.utilities 
{
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Grid 
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Array;
		private var _cols:int;
		private var _rows:int;
		
		
		public function Grid(cols:int, rows:int) 
		{
			_cols = cols;
			_rows = rows;
			_nodes = new Array();
			
			for (var i:int = 0; i < _cols; i++)
			{
				_nodes[i] = new Array();
				for (var j:int = 0; j < _rows; j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		public function getNode(x:int, y:int):Node
		{
			return _nodes[x][y] as Node;
		}
		
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _nodes[x][y] as Node;
		}
		
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y] as Node;
		}
		
		public function setTileDataId(x:int, y:int, value:uint):void
		{
			_nodes[x][y].tileDataId = value;
		}
		
		public function getTileDataId(x:int, y:int):uint
		{
			return _nodes[x][y].tileDataId;
		}
		
		public function isWalkable(col:int, row:int):Boolean
		{
			return _nodes[col][row].walkable;
		}
		
		public function setWalkable(x:int, y:int, value:Boolean):void
		{
			_nodes[x][y].walkable = value;
		}
		
		public function isOccupied(col:int, row:int):Boolean
		{
			return _nodes[col][row].occupied;
		}
		
		public function setOccupied(x:int, y:int, value:Boolean):void
		{
			_nodes[x][y].occupied = value;
		}
		
		public function isHighlighted(col:int, row:int):Boolean
		{
			return _nodes[col][row].highlighted;
		}
		
		public function setHighlighted(x:int, y:int, value:Boolean):void
		{
			_nodes[x][y].highlighted = value;
		}
		
		public function get endNode():Node
		{
			return _endNode;
		}
		
		public function get cols():int
		{
			return _cols;
		}
		
		public function get rows():int
		{
			return _rows;
		}
		
		public function get startNode():Node
		{
			return _startNode;
		}
	}
}