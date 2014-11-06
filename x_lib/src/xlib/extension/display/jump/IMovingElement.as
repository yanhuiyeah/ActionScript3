package xlib.extension.display.jump
{
	/**
	 *移动元素接口
	 * @author yeah
	 */	
	public interface IMovingElement
	{
		/**
		 *是否是向前的 
		 * @return 
		 */		
		function get forward():Boolean;
		function set forward($value:Boolean):void;
		
		/**
		 *速度 
		 * @return 
		 */		
		function get speed():int;
		function set speed($value:int):void;

		/**
		 *加速度 
		 * @return 
		 */		
		function get accelerate():int;
		function set accelerate($value:int):void;
		
	}
}