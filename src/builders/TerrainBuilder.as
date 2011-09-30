package builders
{	
	import net.flashpunk.World;
	
	import graph.Grid;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class TerrainBuilder 
	{
		private var _terrainBuilderStrategy:TerrainBuilderStrategy;
		
		public function TerrainBuilder(terrainBuilderStrategy:TerrainBuilderStrategy) 
		{
			_terrainBuilderStrategy = terrainBuilderStrategy;
		}
		
		public function build(world:World, grid:Grid, cellSize:int):Terrain
		{
			return _terrainBuilderStrategy.build(world, grid, cellSize);
		}
	}
}