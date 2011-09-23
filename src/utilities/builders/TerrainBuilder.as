package utilities.builders
{	
	import com.hovotz.utilities.Grid;
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
		
		public function build(grid:Grid, cellSize:int):Terrain
		{
			return _terrainBuilderStrategy.build(grid, cellSize);
		}
	}
}