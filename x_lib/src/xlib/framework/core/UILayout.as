package xlib.framework.core
{
	import xlib.framework.core.interfaces.ILayoutElement;
	import xlib.framework.events.UIEvent;
	import xlib.framework.xlib_internal;
	
	use namespace xlib_internal;
	
	/**移动*/
	[Event(name="move", type="xlib.framework.events.UIEvent")]
	
	/**
	 *可参与布局的ui 
	 * @author yeah
	 */	
	public class UILayout extends UIInvalidate implements ILayoutElement
	{
		public function UILayout()
		{
			super();
		}
		
		private var _autoLayout:Boolean = true;
		public function get autoLayout():Boolean
		{
			return _autoLayout;
		}
		
		public function set autoLayout($value:Boolean):void
		{
			if(_autoLayout == $value) return;
			_autoLayout = $value;
			invalidateSize();
		}
		
		private var _left:Number = NaN;
		public function get left():Number
		{
			return _left;
		}
		
		public function set left($value:Number):void
		{
			if(_left == $value) return;
			_left = $value;
			invalidateParent();
		}
		
		private var _right:Number = NaN;
		public function get right():Number
		{
			return _right;
		}
		
		public function set right($value:Number):void
		{
			if(_right == $value) return;
			_right = $value;
			invalidateParent();
		}
		
		private var _top:Number = NaN;
		public function get top():Number
		{
			return _top;
		}
		
		public function set top($value:Number):void
		{
			if(_top == $value) return;
			_top = $value;
			invalidateParent();
		}
		
		private var _bottom:Number = NaN;
		public function get bottom():Number
		{
			return _bottom;
		}
		
		public function set bottom($value:Number):void
		{
			if(_bottom == $value) return;
			_bottom = $value;
			invalidateParent();
		}
		
		private var _verticalCenter:Number = NaN;
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		
		public function set verticalCenter($value:Number):void
		{
			if(verticalCenter == $value) return;
			_verticalCenter = $value;
			invalidateParent();
		}
		
		private var _horizontalCenter:Number = NaN;
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		
		public function set horizontalCenter($value:Number):void
		{
			if(_horizontalCenter == $value) return;
			_horizontalCenter = $value;
			invalidateParent();
		}
		
		private var _percentWidth:Number = NaN;
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		
		public function set percentWidth($value:Number):void
		{
			if(_percentWidth == $value) return;
			_percentWidth = $value;
			invalidateParent();
		}
		
		private var _percentHeight:Number = NaN;
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		public function set percentHeight($value:Number):void
		{
			if(_percentHeight == $value) return;
			_percentHeight = $value;
			invalidateParent();
		}
		
		private var layoutWidthSet:Boolean = false;
		private var layoutHeightSet:Boolean = false;
		public function setLayoutSize($width:Number, $height:Number):void
		{
			_width = $width;
			_height = $height;
			layoutWidthSet = !isNaN($width);
			layoutHeightSet = !isNaN($height);
			setActualSize(priorityWidth, priorityHeight);
		}
		
		override public function get priorityWidth():Number
		{
			return layoutWidthSet ? _width : super.priorityWidth;
		}
		
		override public function get priorityHeight():Number
		{
			return layoutHeightSet ? _height:super.priorityHeight;
		}
		
		public function setLayoutPosition($x:Number, $y:Number):void
		{
			move($x, $y);
		}
		
		override public function set x(value:Number):void
		{
			if(super.x == value) return;
			super.x = value;
			invalidateParent();
		}
		
		override public function set y(value:Number):void
		{
			if(super.y == value) return;
			super.y = value;
			invalidateParent();
		}
		
		override xlib_internal function measureSize():Boolean
		{
			var changed:Boolean = super.measureSize();
			if(changed)
			{
				invalidateParent();
			}
			return changed;
		}
		
		/**
		 *移动 
		 * @param $x
		 * @param $y
		 */		
		public function move($x:Number, $y:Number):void
		{
			if(x != $x || y != $y)
			{
				super.x = $x;
				super.y = $y;
				this.dispatchEvent(new UIEvent(UIEvent.MOVE));
				invalidateParent();
			}
		}
		
		/**
		 *父容器 尺寸测量和显示列表更新 失效 
		 */		
		private function invalidateParent():void
		{
			if(!autoLayout) return;
			var p:ILayoutElement = parent as ILayoutElement;
			if(p)
			{
				p.invalidateSize();
				p.invalidateDisplayList();
			}
		}
	}
}