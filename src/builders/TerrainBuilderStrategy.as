package builders 
{
	import net.flashpunk.World;
	
	import graph.Grid;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public interface TerrainBuilderStrategy 
	{
		function build(world:World, grid:Grid, cellSize:int):Terrain;
	}	
}