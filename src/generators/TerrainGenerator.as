package generators
{
	import flash.geom.Rectangle;
	
	import graph.Grid;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class TerrainGenerator 
	{
		private var _tiles:Array;
		private var _walkableMap:Array;
		private var _grid:Grid;
		private var _cols:int;
		private var _rows:int;
			
		public static const NUM_OF_VARIANT:int = 15;
		
		public const T:int 		= 1;
		public const R:int 		= 2;
		public const TR:int 	= 3;
		public const B:int 		= 4;
		public const TB:int 	= 5;
		public const RB:int 	= 6;
		public const TRB:int 	= 7;
		public const L:int 		= 8;
		public const TL:int 	= 9;
		public const RL:int		= 10;
		public const TRL:int 	= 11;
		public const BL:int		= 12;
		public const TBL:int	= 13;
		public const RBL:int	= 14;
		public const TRBL:int	= 15;
		
		public static const LAND:int = 20;
		public static const SAND:int = 40;
		public static const FOREST:int = 80;
		public static const MEADOW:int = 100;
		public static const SWAMP:int = 120;
		public static const STONEY:int = 140;
		public static const RIVER:int = 160;
		public static const WATER:int = 180;
		public static const HILL:int = 200;
		public static const TREE:int = 204;
		public static const TREE_L:int = 205;
		public static const TREE_C:int = 206;
		public static const TREE_R:int = 207;
		
		public function TerrainGenerator() 
		{	
		}
		
		public function generate(cols:int, rows:int):Grid
		{
			_rows = rows;
			_cols = cols;
			_tiles = new Array();
			
			for (var i:int = 0; i < _cols; i++)
			{
				_tiles[i] = new Array();
				for (var j:int = 0; j < _rows; j++)
				{
					if (Math.random() < 0.50)
					{
						_tiles[i][j] = LAND;
					} 
					else
					{
						_tiles[i][j] = WATER;
					}
				}
			}
			
			for (i = 0; i < 8; i++ )
			{
				iterateLand(LAND, WATER);
			}
			
			generateTile(SAND, [LAND], 0.5);
			for (i = 0; i < 8; i++ )
			{
				iterateLand(SAND, LAND);
			}
			
			generateTile(MEADOW, [LAND], 0.6);
			for (i = 0; i < 8; i++ )
			{
				iterateLand(MEADOW, LAND);
			}
			
			generateTile(TREE, [LAND], 0.7);
			for (i = 0; i < 8; i++ )
			{
				iterateLand(TREE, LAND);
			}
			
			applyTransitionTiles();
			createWalkableMap();
			
			_grid = new Grid(_cols, _rows);
			for (i = 0; i < _cols; i++)
			{
				for (j = 0; j < _rows; j++)
				{
					_grid.setTileDataId(i, j, _tiles[i][j]);
					_grid.setWalkable(i, j, _walkableMap[i][j]);
				}
			}
			
			return _grid;
		}

		public function createWalkableMap():Array
		{
			var solidTiles:Array = concatenateAllTilesAndTheirVariant([TerrainGenerator.WATER]).concat(TerrainGenerator.TREE, TerrainGenerator.TREE_C, TerrainGenerator.TREE_L, TerrainGenerator.TREE_R);
			
			_walkableMap = new Array();
			for (var i:int = 0; i < _cols; i++)
			{
				_walkableMap[i] = new Array();
				for (var j:int = 0; j < _rows; j++)
				{
					_walkableMap[i][j] = 1;
					if (solidTiles.indexOf(_tiles[i][j]) !== -1)
					{
						_walkableMap[i][j] = 0;
					}
				}
			}
			return _walkableMap;
		}

		private function concatenateAllTilesAndTheirVariant(baseTiles:Array):Array
		{
			var tilesList:Array = new Array();
			for (var i:int = 0; i < baseTiles.length; i++)
			{
				var temp:Array = getAllVariants(baseTiles[i]);
				for (var j:int = 0; j < temp.length; j++)
				{
					
					tilesList.push(temp[j]);	
				}
			}
			return tilesList;
		}
		
		private function getAllVariants(baseTile:int):Array 
		{
			var tilesList:Array = new Array();
			for (var i:int = 0; i <= TerrainGenerator.NUM_OF_VARIANT; i++)
			{
				tilesList.push(baseTile+i);
			}
			return tilesList;
		}
		
		private function generateTile(tile:int, onTopOf:Array, ratio:Number):void
		{
			for (var i:int = 0; i < _cols; i++)
			{
				for (var j:int = 0; j < _rows; j++)
				{
					for (var k:int = 0; k < onTopOf.length; k++)
					{
						if (_tiles[i][j] == onTopOf[k])
						{
							if (Math.random() < ratio)
							{
								_tiles[i][j] = tile;
							}
						}
					}
				}
			}
		}
		
		private function iterateLand(land:int, defaultLand:int):void
		{
			for (var i:int = 0; i < _cols; i++)
			{
				for (var j:int = 0; j < _rows; j++)
				{
					if (_tiles[i][j] == land || _tiles[i][j] == defaultLand)
					{
						if (adjacentLand(i, j, land) >= 5)
						{
							_tiles[i][j] = land;
						}
						else
						{
							_tiles[i][j] = defaultLand;
						}
					}
				}
			}
		}
		
		private function adjacentLand(col:int, row:int, lookFor:uint):int
		{
			var found:int = 0;
			var startX:int = Math.max(0, col - 1);
			var endX:int = Math.min(_cols - 1, col + 1);
			var startY:int = Math.max(0, row - 1);
			var endY:int = Math.min(_rows - 1, row + 1);
			
			for (var i:uint = startX; i <= endX; i++)
			{
				for (var j:uint = startY; j <= endY; j++)
				{
					if (_tiles[i][j] == lookFor)
					{
						found++;
					}
				}
			}
			
			return found;
		}
		
		private function applyTransitionTiles():void
		{
			for (var i:int = 0; i < _cols; i++)
			{
				for (var j:int = 0; j < _rows; j++)
				{
					if (_tiles[i][j] == WATER)
					{
						correctNeighbors(WATER, i, j);
					}
					else if (_tiles[i][j] == MEADOW)
					{
						correctNeighbors(MEADOW, i, j);
					}
					else if (_tiles[i][j] == SWAMP)
					{
						correctNeighbors(SWAMP, i, j);
					}
					else if (_tiles[i][j] == RIVER)
					{
						correctNeighbors(RIVER, i, j);
					}
					else if (_tiles[i][j] == STONEY)
					{
						correctNeighbors(STONEY, i, j);
					}
					else if (_tiles[i][j] == FOREST)
					{
						correctNeighbors(FOREST, i, j);
					}
					else if (_tiles[i][j] == SAND)
					{
						correctNeighbors(SAND, i, j);
					}
					else if (_tiles[i][j] == TREE)
					{
						var rightOfCurrentTileIsATree:Boolean 			= ((i + 1) > (_cols - 1)) ? false : (_tiles[i + 1][j] == TREE);
						var rightOfRightOfCurrentTileIsATree:Boolean 	= ((i + 2) > (_cols - 1)) ? false : (_tiles[i + 2][j] == TREE);
						
						if (rightOfCurrentTileIsATree && rightOfRightOfCurrentTileIsATree)
						{
							_tiles[i][j] = TREE_L;
							_tiles[i+1][j] = TREE_C;
							_tiles[i+2][j] = TREE_R;
						} 
						else if (rightOfCurrentTileIsATree)
						{
							_tiles[i][j] = TREE_L;
							_tiles[i+1][j] = TREE_R;
						}
					}
				}
			}
		}
		
		private function correctNeighbors(baseTile:int, col:int, row:int):void
		{
			var i:int = col;
			var j:int = row;
			
			var topTileIsVariantOfBaseTile:Boolean;
			var rightTileIsVariantOfBaseTile:Boolean;
			var bottomTileIsVariantOfBaseTile:Boolean;
			var leftTileIsVariantOfBaseTile:Boolean;
			
			topTileIsVariantOfBaseTile 		= ((j - 1) < 0) 			? true : isTileAVariantOf(_tiles[i][j-1], baseTile);
			rightTileIsVariantOfBaseTile 	= ((i + 1) > (_cols - 1))	? true : isTileAVariantOf(_tiles[i+1][j], baseTile);
			bottomTileIsVariantOfBaseTile	= ((j + 1) > (_rows - 1))	? true : isTileAVariantOf(_tiles[i][j+1], baseTile);
			leftTileIsVariantOfBaseTile		= ((i - 1) < 0)				? true : isTileAVariantOf(_tiles[i-1][j], baseTile);
			
			if (!topTileIsVariantOfBaseTile &&
				!rightTileIsVariantOfBaseTile &&
				!bottomTileIsVariantOfBaseTile &&
				!leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TRBL;
			}
			
			else if (!topTileIsVariantOfBaseTile &&
					 !rightTileIsVariantOfBaseTile &&
					 !bottomTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TRB;
			}
			else if (!topTileIsVariantOfBaseTile &&
					 !rightTileIsVariantOfBaseTile &&
					 !leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TRL;
			}
			else if (!topTileIsVariantOfBaseTile &&
					 !bottomTileIsVariantOfBaseTile &&
					 !leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TBL;
			}
			else if (!rightTileIsVariantOfBaseTile &&
					 !bottomTileIsVariantOfBaseTile &&
					 !leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + RBL;
			}
			
			
			else if (!topTileIsVariantOfBaseTile &&
					 !rightTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TR;
			}
			else if (!topTileIsVariantOfBaseTile &&
					 !bottomTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TB;
			}
			else if (!rightTileIsVariantOfBaseTile &&
					 !bottomTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + RB;
			}
			else if (!topTileIsVariantOfBaseTile &&
					 !leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + TL;
			}
			else if (!rightTileIsVariantOfBaseTile &&
					 !leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + RL;
			}
			else if (!bottomTileIsVariantOfBaseTile &&
					 !leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + BL;
			}
			
			else if (!topTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + T;
			}
			else if (!rightTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + R;
			}
			else if (!bottomTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + B;
			}
			else if (!leftTileIsVariantOfBaseTile)
			{
				_tiles[i][j] = baseTile + L;
			}
		}
		
		private function isTileAVariantOf(variant:int, tile:int):Boolean
		{
			if (variant >= tile && variant <= tile + NUM_OF_VARIANT)
			{
				return true;
			}
			return false;
		}
	}
}