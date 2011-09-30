package builders 
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	
	import entities.Highlight;
	
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	import graph.Node;
	import graph.Grid;
	import algorithms.AStar;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Terrain 
	{
		private var _world:World;
		
		private var _tiles:Array;
		private var _highlightedCells:Array;
		private var _highlightedNodes:Array;
		
		private var _astar:AStar;
		private var _grid:Grid;
		
		private var _cols:int;
		private var _rows:int;
		private var _cellSize:int;
		
		private var _width:int;
		private var _height:int;
		
		public function get grid():Grid
		{
			return _grid;
		}
		
		public function get tiles():Array
		{
			return _tiles;
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
		
		public function Terrain(world:World, grid:Grid, width:int, height:int, cellSize:int) 
		{	
			_tiles = new Array();
			_world = world;
			_grid = grid;
			_cols = _grid.cols;
			_rows = _grid.rows;
			_width = width;
			_height = height;
			_cellSize = cellSize;
		}
		
		public function addTile(tile:Entity):void
		{
			_tiles.push(tile);
			_world.add(tile);
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
		
		public function isHighlighted(col:int, row:int):Boolean
		{
			return _grid.getNode(col, row).highlighted;
		}
		
		public function setHighlighted(col:int, row:int, value:Boolean):void
		{
			_grid.setHighlighted(col, row, value);
		}
		
		public function findPath(startCol:int, startRow:int, endCol:int, endRow:int):Boolean
		{
			_grid.setOccupied(startCol, startRow, false);
			_grid.setEndNode(endCol, endRow);
			_grid.setStartNode(startCol, startRow);
			
			_astar = new AStar();
			return _astar.findPath(_grid);
		}
		
		public function highlightCells(col:int, row:int, distance:int):void
		{
			var astar:AStar = new AStar();
			_highlightedNodes = astar.findMovementRange(col, row, distance, grid);
			_highlightedCells = new Array();
			for (var i:int = 0; i < _highlightedNodes.length; i++)
			{
				var node:Node = _highlightedNodes[i];
				node.highlighted = true;
				
				var highlightPositionInScreenSpace:Point = IsoUtils.isoToScreen(new Point3D(node.col * cellSize, 0, node.row * cellSize))
				var highlight:Highlight = new Highlight();
				highlight.x = highlightPositionInScreenSpace.x;
				highlight.y = highlightPositionInScreenSpace.y;
				highlight.layer = 3;
				_highlightedCells.push(highlight);
				_world.add(highlight);
			}
		}
		
		public function unhighlightCells():void
		{
			for each (var node:Node in _highlightedNodes)
			{
				node.highlighted = false;
			}
			_world.removeList(_highlightedCells);
		}
		
		public function get path():Array
		{
			return _astar.path;
		}
	}
}