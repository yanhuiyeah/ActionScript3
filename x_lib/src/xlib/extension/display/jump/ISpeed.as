package xlib.extension.display.jump
{
	import flash.display.DisplayObject;

	public interface ISpeed
	{
		
		/**
		 *加速度 
		 * @return 
		 */		
		function get accelerate():int;
		function set accelerate($value:int):void;
		
		/**
		 *当前速度 
		 * @return 
		 */		
		function get speed():int;
		function set speed($value:int):void;
		
		/**
		 *水平方向 
		 * @return 
		 */		
		function get horizontalDirection():int;
		function set horizontalDirection($value:int):void;
		
		/**
		 *垂直方向 
		 * @return 
		 */		
		function get verticalDirection():int;
		function set verticalDirection($value:int):void;
		
		/**
		 *返回本身 
		 * @return 
		 */		
		function get self():DisplayObject;
		
		
	}
}