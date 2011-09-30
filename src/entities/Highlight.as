package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class Highlight extends Entity 
	{
		public function Highlight() 
		{
			var image:Image = new Image(Assets.ISO_SELECTOR_WHITE);
			image.originX = 30;
			image.originY = 0;
			graphic = image;
		}	
	}
}