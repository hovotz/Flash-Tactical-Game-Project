package entities 
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class DamagePopUp extends Entity
	{
		private var _damageText:Text;
		
		private var _duration:Number = 0.5;
		private var _counter:Number = 0.0;
		
		public function DamagePopUp(x:int, y:int, damage:int) 
		{
			_damageText = new Text("" + damage);
			_damageText.color = 0xFFFFFF;
			_damageText.size = 18;
			this.x = x - (_damageText.width / 2);
			this.y = y;
			
			var outline:GlowFilter = new GlowFilter()
			outline.blurX = outline.blurY = 1.2;
			outline.color = 0x333333;
			outline.quality = BitmapFilterQuality.HIGH;
			outline.strength = 100;

			var filterArray:Array = new Array();
			filterArray.push(outline);
			_damageText.getTextField().filters = filterArray;
			_damageText.updateTextBuffer();
			
			graphic = _damageText;
		}
		
		override public function update():void
		{
			trace(_counter)
			_counter += FP.elapsed;
			y -= 2;
			if (_counter > _duration)
			{
				world.remove(this);
			}
		}
	}
}