package backups
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	//import net.flashpunk.masks.Grid;
	import net.flashpunk.FP;
	
	import com.hovotz.utilities.TerrainGenerator;
	import com.hovotz.utilities.AStar;
	import com.hovotz.utilities.Grid;
	import com.hovotz.utilities.Node;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Terrain extends Entity 
	{
		private var _tilemap:Tilemap;
		private var _astar:AStar;
		private var _grid:Grid;
		private var _rows:int;
		private var _cols:int;
		private var _cellSize:int;
		
		public function get rows():int
		{
			return _rows;
		}
		
		public function get cols():int
		{
			return _cols;
		}
		
		public function get cellSize():int
		{
			return _cellSize;
		}
		
		public function Terrain(cols:int, rows:int, gridSize:int) 
		{
			_cols = cols;
			_rows = rows;
			_cellSize = gridSize;
			var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			_grid = terrainGenerator.generate(_cols, _rows);
			_tilemap = new Tilemap(Assets.TILESET, _cols * _cellSize, _rows * _cellSize, _cellSize, _cellSize);
			//_grid = new Grid(_cols * _cellSize, _rows * _cellSize, _cellSize, _cellSize);
			for (var i:int = 0; i < _cols; i++)
			{
				for (var j:int = 0; j < _rows; j++)
				{
					_tilemap.setTile(i, j, _grid.getTileDataId(i, j));
				}
			}
			drawGrid();
			graphic = _tilemap;
			//mask = _grid;
			layer = 1;
			type = "solid";
			this.width = _tilemap.width;
			this.height = _tilemap.height;
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
	}
}