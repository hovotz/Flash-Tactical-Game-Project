package entities.selectors 
{
	import com.hovotz.utilities.Grid;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	
	public class IsometricSelector extends Entity
	{
		private var _unwalkableImage:Image = new Image(Assets.ISO_SELECTOR_RED);
		private var _walkableImage:Image = new Image(Assets.ISO_SELECTOR_WHITE);
		private var _occupiedImage:Image = new Image(Assets.ISO_SELECTOR_GREEN);
		
		public function IsometricSelector() 
		{
			_unwalkableImage.originX = 30;
			_unwalkableImage.originY = 0;
			
			_walkableImage.originX = 30;
			_walkableImage.originY = 0;
			
			_occupiedImage.originX = 30;
			_occupiedImage.originY = 0;
		}
		
		public function show():void
		{
			if (graphic)
			{
				graphic.visible = true;
			}
		}
		
		public function hide():void
		{
			if (graphic)
			{
				graphic.visible = false;
			}
		}
		
		public function cellIsWalakble():void
		{
			graphic = _walkableImage;
		}
		
		public function cellIsUnWalkable():void
		{
			graphic = _unwalkableImage;
		}
		
		public function cellIsOccupied():void
		{
			graphic = _occupiedImage;
		}
	}
}