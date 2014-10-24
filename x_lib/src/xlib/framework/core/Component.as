package xlib.framework.core
{
	import xlib.framework.core.interfaces.IComponent;
	
	/**
	 *组件基类 
	 * @author yeah
	 */	
	public class Component extends UILayout implements IComponent
	{
		public function Component()
		{
			super();
		}
		
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
		
	}
}