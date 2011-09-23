package utilities.builders 
{
	import com.hovotz.utilities.Grid;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public interface TerrainBuilderStrategy 
	{
		function build(grid:Grid, cellSize:int):Terrain;
	}	
}