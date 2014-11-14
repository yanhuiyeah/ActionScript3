package display.moving
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	public interface IMovingElement extends IEventDispatcher
	{
		/**
		 *水平移动元素 
		 * @return 
		 */		
		function get hData():IMovingData;
		function set hData($value:IMovingData):void;
		
		/**
		 *竖直移动元素
		 * @return 
		 */		
		function get vData():IMovingData;
		function set vData($value:IMovingData):void;
		
		/**
		 *target 
		 * @return 
		 */		
		function get target():DisplayObject;
		function set target($value:DisplayObject):void;
	}
}