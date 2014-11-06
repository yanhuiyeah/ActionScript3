package xlib.extension.display.jump
{
	import flash.display.DisplayObject;

	public interface IMoving
	{
		/**
		 *水平移动元素 
		 * @return 
		 */		
		function get horizontal():IMovingElement;
		function set horizontal($value:IMovingElement):void;
		
		/**
		 *竖直移动元素
		 * @return 
		 */		
		function get vertical():IMovingElement;
		function set vertical($value:IMovingElement):void;
		
		/**
		 *返回本身实例 
		 * @return 
		 */		
		function get self():DisplayObject;
		
		/**
		 *运行 
		 */		
		function go():void;

		/**
		 *杀死 
		 */		
		function kill():void;
	}
}