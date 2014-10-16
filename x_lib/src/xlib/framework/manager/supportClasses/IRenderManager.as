package xlib.framework.manager.supportClasses
{
	import flash.events.IEventDispatcher;
	
	import xlib.framework.core.IInvalidateElement;
	
	
	/**
	 *延时生效布局生效渲染管理器 接口
	 * @author yeah
	 */	
	public interface IRenderManager extends IEventDispatcher
	{
		/**
		 *属性失效 ， 下一帧或者下一个Render事件生效
		 * @param $element
		 */		
		function invalidateProperties($element:IInvalidateElement):void;
		
		/**
		 *度量失效 ， 下一帧或者下一个Render事件生效
		 * @param $element
		 */		
		function invalidateSize($element:IInvalidateElement):void;
		
		/**
		 *更新显示列表失效 ， 下一帧或者下一个Render事件生效
		 * @param $element
		 */		
		function invalidateDisplayList($element:IInvalidateElement):void;
		
		/**
		 *立即生效 
		 */		
		function validateNow():void;

		/**
		 *使嵌套级别(nestLevel)大于或等于$element.nestLevel的所有组件中的所有失效元素 生效<br>
		 * 效率较低，一般不推荐使用
		 * @param $element
		 */		
		function validateElement($element:IInvalidateElement):void;
	}
}