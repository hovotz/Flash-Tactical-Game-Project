package utilities.builders 
{
	import flash.geom.Point;
	import utilities.isometricprojection.Point3D;
	import com.hovotz.utilities.Grid;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Entity;
	import utilities.isometricprojection.IsoUtils;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class IsomapTerrainBuilderStrategy implements TerrainBuilderStrategy 
	{
		public function IsomapTerrainBuilderStrategy() 
		{	
		}
		
		public function build(grid:Grid, cellSize:int):Terrain
		{
			var width:int = (grid.cols + grid.rows) * cellSize;
			var height:int = (grid.cols + grid.rows) * (cellSize / 2);
			var terrain:Terrain = new Terrain(grid, width, height, cellSize);
			for (var i:int = 0; i < grid.cols; i++)
			{
				for (var j:int = 0; j < grid.rows; j++)
				{
					var position3D:Point3D = new Point3D(30 * i, 0, 30 * j);
					var position:Point = IsoUtils.isoToScreen(position3D);
					var index:int = grid.getTileDataId(i, j);
					var tileX:int = index * 64;
					var tileY:int = int(tileX / (64 * 20)) * 32;
					tileX %= (64 * 20);
					var rect:Rectangle = new Rectangle(tileX, tileY, 64, 32);
					var image:Image = new Image(Assets.ISOTILESET, rect);
					image.originX = 30;
					image.originY = 0;
					var entity:Entity = new Entity(position.x, position.y, image);
					terrain.add(entity);
				}
			}
			return terrain;
		}
	}
}