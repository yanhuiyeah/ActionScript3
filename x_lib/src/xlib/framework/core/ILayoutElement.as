package xlib.framework.core
{
	import flash.events.IEventDispatcher;
	
	/**
	 *布局element 
	 * @author yeah
	 */	
	public interface ILayoutElement extends IEventDispatcher
	{
		/**
		 *布局代理 
		 * @return 
		 */		
		function get layoutProxy():LayoutProxy;
		
		/**
		 *是否使用布局代理 
		 * @return 
		 */		
		function get useLayoutProxy():Boolean;
		function set useLayoutProxy($value:Boolean):void;
	}
}