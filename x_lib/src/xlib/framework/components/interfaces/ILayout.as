package xlib.framework.components.interfaces
{
	import flash.events.IEventDispatcher;
	

	/**
	 *布局管理器接口 
	 * @author yeah
	 */	
	public interface ILayout extends IEventDispatcher
	{
		/**
		 *目标容器 
		 * @return 
		 */		
		function get target():IContainer;
		function set target($value:IContainer):void;
		
		/**
		 *度量 target
		 */		
		function measure():void;
		
		/**
		 *更新target显示列表 
		 * @param $width
		 * @param $height
		 */		
		function updateDisplayList($width:Number, $height:Number):void;
	}
}