package forms 
{
	import org.aswing.border.EmptyBorder;
	import org.aswing.BoxLayout;
	import org.aswing.EmptyLayout;
	import org.aswing.geom.IntPoint;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.FlowLayout;
	import org.aswing.geom.IntDimension;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class UnitActionMenuForm extends JFrame 
	{
		public static const NORMAL_APPEARANCE:String = "normal_appearance";
		public static const CANCEL_APPEARANCE:String = "cancel_appearance";
	
		private var _panel:JPanel;
		private var _attackButton:JButton;
		private var _moveButton:JButton;
		private var _waitButton:JButton;
		private var _cancelButton:JButton;
		
		public function UnitActionMenuForm(owner:*=null, title:String="", modal:Boolean=false) 
		{
			super(owner, title, modal);
			
			this.setClosable(false);
			this.setResizable(false);
			this.setDragable(false);
			
			_attackButton = new JButton("Attack");
			_attackButton.setPreferredSize(new IntDimension(100, 25));
			
			_moveButton = new JButton("Move");
			_moveButton.setPreferredSize(new IntDimension(100, 25));
			
			_waitButton = new JButton("Wait");
			_waitButton.setPreferredSize(new IntDimension(100, 25));
			
			_cancelButton = new JButton("Cancel");
			_cancelButton.setPreferredSize(new IntDimension(100, 25));
			
			_panel = new JPanel(new BoxLayout(BoxLayout.Y_AXIS));
			_panel.setBorder(new EmptyBorder(null, new Insets(7, 2, 0, 0)));
			_panel.appendAll(_attackButton, _moveButton, _waitButton, _cancelButton);
			this.getContentPane().append(_panel);
			pack();
			this.show();
		}
		
		public function changeAppearance(appearance:String):void
		{
			switch(appearance)
			{
				case NORMAL_APPEARANCE:
					_attackButton.setVisible(true);
					_moveButton.setVisible(true);
					_waitButton.setVisible(true);
					_cancelButton.setVisible(false);
					break;
					
				case CANCEL_APPEARANCE:
					_attackButton.setVisible(false);
					_moveButton.setVisible(false);
					_waitButton.setVisible(false);
					_cancelButton.setVisible(true);
					break;
			}
			pack();
		}
		
		public function get attackButton():JButton
		{
			return _attackButton;
		}
		
		public function get moveButton():JButton
		{
			return _moveButton;
		}
		
		public function get waitButton():JButton
		{
			return _waitButton;
		}
		
		public function get cancelButton():JButton
		{
			return _cancelButton;
		}
	}
}