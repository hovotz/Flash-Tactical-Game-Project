package forms 
{
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
		private var _panel:JPanel;
		private var _attackButton:JButton;
		private var _moveButton:JButton;
		private var _waitButton:JButton;
		
		public function UnitActionMenuForm(owner:*=null, title:String="", modal:Boolean=false) 
		{
			super(owner, title, modal);
			
			this.setSizeWH(117, 125);
			this.setClosable(false);
			this.setResizable(false);
			this.setDragable(false);
			
			_attackButton = new JButton("Attack");
			_attackButton.setPreferredSize(new IntDimension(100, 25));
			
			_moveButton = new JButton("Move");
			_moveButton.setPreferredSize(new IntDimension(100, 25));
			
			_waitButton = new JButton("Wait");
			_waitButton.setPreferredSize(new IntDimension(100, 25));
			
			_panel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			_panel.appendAll(_attackButton, _moveButton, _waitButton);
			this.getContentPane().append(_panel);
			this.show();
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
	}
}