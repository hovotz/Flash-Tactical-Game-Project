package utilities.builders 
{
	import adobe.utils.CustomActions;
	import com.hovotz.utilities.AStar;
	import com.hovotz.utilities.Grid;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Terrain 
	{
		private var _entities:Array;
		
		private var _astar:AStar;
		private var _grid:Grid;
		
		private var _cols:int;
		private var _rows:int;
		private var _cellSize:int;
		
		private var _width:int;
		private var _height:int;
		
		public function get entities():Array
		{
			return _entities;
		}
		
		public function get cols():int
		{
			return _cols;
		}
		
		public function get rows():int
		{
			return _rows;
		}
		
		public function get cellSize():int
		{
			return _cellSize;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function Terrain(grid:Grid, width:int, height:int, cellSize:int) 
		{	
			_entities = new Array();
			_grid = grid;
			_cols = _grid.cols;
			_rows = _grid.rows;
			_width = width;
			_height = height;
			_cellSize = cellSize;
		}
		
		public function add(entity:Entity):void
		{
			_entities.push(entity);
		}
		
		public function isWalkable(col:int, row:int):Boolean
		{
			return _grid.getNode(col, row).walkable;
		}
		
		public function setWalkable(col:int, row:int, value:Boolean):void
		{
			_grid.setWalkable(col, row, value);
		}
		
		public function isOccupied(col:int, row:int):Boolean
		{
			return _grid.getNode(col, row).occupied;
		}
		
		public function setOccupied(col:int, row:int, value:Boolean):void
		{
			_grid.setOccupied(col, row, value);
		}
		
		public function findPath(startCol:int, startRow:int, endCol:int, endRow:int):Boolean
		{
			_grid.setOccupied(startCol, startRow, false);
			_grid.setEndNode(endCol, endRow);
			_grid.setStartNode(startCol, startRow);
			
			_astar = new AStar();
			return _astar.findPath(_grid);
		}
		
		public function get path():Array
		{
			return _astar.path;
		}
		
		/*
		private function drawGrid():void
		{
			for ( var i:int = 0; i < _tilemap.columns; i++ )
			{
				for ( var j:int = 0; j < _tilemap.rows; j++ )
				{
					if (_grid.getNode(i, j).walkable)
					{
						_tilemap.draw(i * _cellSize, j * _cellSize, FP.getBitmap(Assets.BOX));
					}
				}
			}
		}
		
		public function draw(col:int, row:int):void
		{
			_tilemap.draw(col * _cellSize, row * cellSize, FP.getBitmap(Assets.MOUSE_CLICK_MARKER));
		}
		*/
	}
}