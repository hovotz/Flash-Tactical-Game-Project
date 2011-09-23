package utilities.builders 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	
	import com.hovotz.utilities.Grid;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class TilemapTerrainBuilderStrategy implements TerrainBuilderStrategy 
	{
		public function TilemapTerrainBuilderStrategy() 
		{	
		}
		
		public function build(grid:Grid, cellSize:int):Terrain
		{
			var width:int = grid.cols * cellSize;
			var height:int = grid.rows * cellSize;
			var tilemap:Tilemap = new Tilemap(Assets.TILESET, width, height, cellSize, cellSize);
			for (var i:int = 0; i < grid.cols; i++)
			{
				for (var j:int = 0; j < grid.rows; j++)
				{
					tilemap.setTile(i, j, grid.getTileDataId(i, j));
				}
			}
			var terrain:Terrain = new Terrain(grid, tilemap.width, tilemap.height, cellSize);
			var tilemapEntity:Entity = new Entity(0, 0, tilemap);
			tilemapEntity.layer = 1;
			terrain.add(tilemapEntity);
			return terrain;
		}
	}
}