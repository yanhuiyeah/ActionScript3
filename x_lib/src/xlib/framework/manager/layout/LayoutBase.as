package xlib.framework.manager.layout
{
	import flash.events.IEventDispatcher;
	
	import xlib.framework.components.Container;
	import xlib.framework.components.interfaces.IContainer;
	import xlib.framework.components.interfaces.ILayout;
	import xlib.framework.core.LazyDispatcher;
	
	/**
	 *布局管理器基类 
	 * @author yeah
	 */	
	public class LayoutBase extends LazyDispatcher implements ILayout
	{
		public function LayoutBase($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		private var _target:IContainer;
		public function get target():IContainer
		{
			return _target;
		}
		
		public function set target($value:IContainer):void
		{
			if(_target == $value) return;
			_target = $value;
		}
		
		public function measure():void
		{
		}
		
		public function updateDisplayList($width:Number, $height:Number):void
		{
		}
	}
}