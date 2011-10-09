package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import worlds.UIWorld;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	import worlds.CombatWorld;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	[SWF(width = "640", height = "480")]
	[Frame(factoryClass="Preloader")]
	public class Main extends Engine
	{		
		public function Main():void 
		{
			super(640, 480, 60, false);
			//FP.console.enable();
		}	
		
		override public function init():void
		{
			super.init();
			FP.world = new CombatWorld();
		}
	}	
}