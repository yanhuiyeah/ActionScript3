package xlib.framework.core
{
	import xlib.framework.core.interfaces.IComponent;
	import xlib.framework.theme.ThemeUtil;
	
	/**
	 *组件基类 （不是容器，尽量不要添加子现实对象;容器请使用Container）<br>
	 * 无鼠标事件
	 * @author yeah
	 */	
	public class Component extends UILayout implements IComponent
	{
		public function Component()
		{
			super();
			mouseEnabled = mouseChildren = false;
		}
		
		private var enabledChanged:Boolean = false;
		private var _enabled:Boolean = true;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled($value:Boolean):void
		{
			if(_enabled == $value) return;
			_enabled = $value;
			if(_enabled)
			{
				super.mouseEnabled = _mouseEnabled;
				super.mouseChildren = _mouseChildren;
			}
			else
			{
				super.mouseEnabled = false;
				super.mouseChildren = false;
			}
			
			enabledChanged = true;
			invalidateProperties();
		}
		
		private var _mouseEnabled:Boolean = true;
		override public function set mouseEnabled($value:Boolean):void
		{
			if(super.mouseEnabled == $value) return;
			super.mouseEnabled = $value;
			_mouseEnabled = $value;
		}
		
		private var _mouseChildren:Boolean = true;
		override public function set mouseChildren($value:Boolean):void
		{
			if(super.mouseChildren == $value) return;
			super.mouseChildren = $value;
			_mouseChildren = $value;
		}
		
		private var _toolTips:Object;
		public function get toolTips():Object
		{
			return _toolTips;
		}
		
		public function set toolTips($value:Object):void
		{
			this.toolTips = $value;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(enabledChanged)
			{
				//test
				this.transform.colorTransform = enabled ? ThemeUtil.defaultTransform : 	ThemeUtil.fadeTransform;			
				enabledChanged = false;
			}
		}
		
		override protected function updateDisplayList($width:Number, $height:Number):void
		{
			super.updateDisplayList($width, $height);
			if(showBorder)
			{
				this.graphics.clear();
				this.graphics.lineStyle(1, 0x0000ff);
				this.graphics.drawRect(0, 0 , $width, $height);
			}
		}
		
		private var _showBorder:Boolean = false;
		
		/**
		 *是否显示边框 
		 * @return 
		 */		
		public function get showBorder():Boolean
		{
			return _showBorder;
		}
		
		public function set showBorder(value:Boolean):void
		{
			_showBorder = value;
			updateDisplayList(priorityWidth, priorityHeight);
		}
		
	}
}