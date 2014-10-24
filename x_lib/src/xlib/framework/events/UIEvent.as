package xlib.framework.events
{
	import flash.events.Event;
	
	/**
	 *UI事件 
	 * @author yeah
	 */	
	public class UIEvent extends Event
	{
		
		/**
		 *初始化完成
		 */		
		public static const INITIALIZED:String = "initialized";
		
		/**
		 *生效机制 三个阶段全部完成 
		 */		
		public static const UPDATE_COMPLETE:String = "updateComplete";
		
		/**
		 组件创建完成 （执行完 第一次失效机制）
		 */		
		public static const CREATE_COMPLETE:String = "createComplete";
		
		/**
		 *组件位置改变 
		 */		
		public static const MOVE:String = "move";
		
		/**
		 *组件尺寸改变 
		 */		
		public static const RESIZE:String = "resize";
		
		/**
		 *内容尺寸发生变化 
		 */		
		public static const CONTENT_SIZE_CHANGED:String = "contentSizeChanged";
		
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}