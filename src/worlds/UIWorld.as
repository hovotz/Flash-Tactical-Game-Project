package worlds 
{
	import net.flashpunk.World;
	import punk.ui.PunkRadioButton;
	import punk.ui.PunkRadioButtonGroup;
	import punk.ui.PunkTextArea;
	import punk.ui.skins.RolpegeBlue;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPasswordField;
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;
	import punk.ui.PunkToggleButton;
	import punk.ui.PunkUI;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class UIWorld extends World 
	{
		public var button:PunkButton;
		
		public function UIWorld() 
		{
			super();
			
			PunkUI.skin = new RolpegeBlue;
			
			button = new PunkButton(170, 300, 300, 140, "Press me");
			button.setCallbacks(onReleased, onPressed, onEnter, onExit);
			add(button);
			add(new PunkToggleButton(10, 40, 100, 25, false, "Toggle me"));
			add(new PunkLabel("Read me", 125, 10));
			add(new PunkTextField("Write something", 125, 40, 200));
			add(new PunkPasswordField(125, 70, 200));
			add(new PunkTextArea("You could write a book here!", 330, 10, 300, 228));
			
			var group:PunkRadioButtonGroup = new PunkRadioButtonGroup;
			add(new PunkRadioButton(group, "", 10, 70, 100, 25, true, "Select me!"));
			add(new PunkRadioButton(group, "", 10, 100, 100, 25, false, "Select me!"));
			add(new PunkRadioButton(group, "", 10, 130, 100, 25, false, "Select me!"));
		}
		
		public function onReleased():void
		{
			button.label.text = "You released me!";
		}
		
		public function onPressed():void
		{
			button.label.text = "You pressed me!";
		}
		
		public function onEnter():void
		{
			button.label.text = "You touched me!";
		}
		
		public function onExit():void
		{
			button.label.text = "You stopped touching me!";
		}
	}
}