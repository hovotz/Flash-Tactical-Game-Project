package worlds 
{
	import flash.events.*;
	import net.flashpunk.*;
	import org.aswing.*;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class AsWingWorld extends World 
	{
		private var frame:JFrame;
		private var panel:JPanel;
		private var label:JLabel;
		private var button:JButton;
		
		private var buttonWasClicked:Boolean = false;
		
		public function AsWingWorld() 
		{		
		}
		
		private function CreateGUI():void
		{
			AsWingManager.setRoot(FP.engine);
			
			frame = new JFrame(FP.engine, "Main Window");
			panel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			label = new JLabel("Hello, World! AsWing and FlashPunk usage Demonstration.");
			button = new JButton("Click me");
			
			frame.setSizeWH(FP.width * 0.5, FP.height * 0.5);
			
			frame.setClosable(false);
			
			button.addEventListener(MouseEvent.CLICK, OnButtonClick);
			
			panel.appendAll(label, button);
			
			frame.getContentPane().append(panel);
			
			frame.show();
		}
		
		override public function begin():void
		{
			CreateGUI();
			super.begin();
		}
		
		private function OnButtonClick(e:MouseEvent):void
		{
			if (!buttonWasClicked)
			{
				label.setText("You clicked the button!");
				label.revalidate();
				
				button.setText("Click me again");
				button.revalidate();
				
				JOptionPane.showMessageDialog("AsWing and FlashPunk usage Demonstration", "Hooray, you have clicked the button!", null, null, true, null, JOptionPane.OK);
			}
			else
			{
				label.setText("Hello, World! AsWing and FlashPunk usage Demonstration.");
				label.revalidate();
				
				button.setText("Click me");
				button.revalidate();
			}
			
			buttonWasClicked = !buttonWasClicked;
		}
	}
}