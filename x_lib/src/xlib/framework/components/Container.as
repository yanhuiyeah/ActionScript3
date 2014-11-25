package xlib.framework.components
{
	
	import xlib.framework.components.interfaces.IContainer;
	import xlib.framework.components.interfaces.ILayout;
	import xlib.framework.core.Component;
	import xlib.framework.core.interfaces.ILayoutElement;
	import xlib.framework.manager.layout.DefaultLayout;
	
	/**
	 *容器接口 
	 * @author yeah
	 */	
	public class Container extends Component implements IContainer
	{
		public function Container()
		{
			super();
		}
		
		private var _layout:ILayout;
		public function get layout():ILayout
		{
			return _layout;
		}
		
		public function set layout($value:ILayout):void
		{
			if($value == _layout) return;
			if(_layout)
			{
				_layout.target = null;
			}
			_layout = $value;
			
			if(_layout)
			{
				_layout.target = this;
			}
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _paddingLeft:Number = 0;
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft($value:Number):void
		{
			if(_paddingLeft == $value) return;
			_paddingLeft = $value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _paddingRight:Number = 0;
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight($value:Number):void
		{
			if(_paddingRight == $value) return;
			_paddingRight = $value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _paddingTop:Number = 0;
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop($value:Number):void
		{
			if(_paddingTop == $value) return;
			_paddingTop = $value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _paddingBottom:Number = 0;
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom($value:Number):void
		{
			if(_paddingBottom == $value) return;
			_paddingBottom = $value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function getElementAt($index:int):ILayoutElement
		{
			return getChildAt($index) as ILayoutElement;
		}
		
		public function get numElements():int
		{
			return numChildren;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.layout = new DefaultLayout();
		}
		
		override protected function measure():void
		{
			if(layout)
			{
				layout.measure();
			}
			else
			{
				super.measure();
			}
		}
		
		override protected function updateDisplayList($width:Number, $height:Number):void
		{
			super.updateDisplayList($width, $height);
			if(layout)
			{
				layout.updateDisplayList($width, $height);
			}
		}
	}
}