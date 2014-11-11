package display.jump
{
	/**
	 *移动元素接口
	 * @author yeah
	 */	
	public interface IMovingElement
	{
		/**
		 *变化比率（1向前， -1 向后） 
		 * @return 
		 */		
		function get rate():int;
		function set rate($value:int):void;
		
		/**
		 *速度最大值，speed达到此值方向改变 (默认-1，无限制)
		 */		
		function get maxSpeed():int;
		function set maxSpeed($value:int):void;
		
		/**
		 *速度最小值 ，speed达到此值方向改变 (默认-1，无限制)
		 * @return 
		 */		
		function get miniSpeed():int;
		function set miniSpeed($value:int):void;
		
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
		
		/**
		 *计算当前速度 并返回带方向的速度值
		 * @return
		 */		
		function calculateSpeed():int;
	}
}