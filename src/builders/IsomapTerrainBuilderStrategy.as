package builders 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.World;
	
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Entity;
	
	import graph.Grid;
	
	import utilities.Point3D;
	import utilities.IsoUtils;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class IsomapTerrainBuilderStrategy implements TerrainBuilderStrategy 
	{
		public function IsomapTerrainBuilderStrategy() 
		{	
		}
		
		public function build(world:World, grid:Grid, cellSize:int):Terrain
		{
			var width:int = (grid.cols + grid.rows) * cellSize;
			var height:int = (grid.cols + grid.rows) * (cellSize / 2);
			var terrain:Terrain = new Terrain(world, grid, width, height, cellSize);
			var isotileHeight:int = cellSize + 2;
			var isotileWidth:int = isotileHeight * 2;
			for (var i:int = 0; i < grid.cols; i++)
			{
				for (var j:int = 0; j < grid.rows; j++)
				{
					var position3D:Point3D = new Point3D(cellSize * i, 0, cellSize * j);
					var position:Point = IsoUtils.isoToScreen(position3D);
					var index:int = grid.getTileDataId(i, j);
					var tileX:int = index * isotileWidth;
					var tileY:int = int(tileX / (isotileWidth * 20)) * isotileHeight;
					tileX %= (isotileWidth * 20);
					var rect:Rectangle = new Rectangle(tileX, tileY, isotileWidth, isotileHeight);
					var image:Image = new Image(Assets.ISOTILESET, rect);
					image.originX = cellSize;
					image.originY = 0;
					var entity:Entity = new Entity(position.x, position.y, image);
					entity.layer = 4;
					terrain.addTile(entity);
				}
			}
			return terrain;
		}
	}
}