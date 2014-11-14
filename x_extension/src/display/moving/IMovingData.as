package display.moving
{
	/**
	 *移动元素接口
	 * @author yeah
	 */	
	public interface IMovingData
	{
		/**
		 * true 加速 false 减速 （默认加速）
		 * @return 
		 */		
		function get quicken():Boolean;
		function set quicken($value:Boolean):void;
		
		/**
		 *速度最大值，开始减速
		 */		
		function get maxSpeed():Number;
		function set maxSpeed($value:Number):void;
		
		/**
		 *速度最小值，开始加速
		 * @return 
		 */		
		function get miniSpeed():Number;
		function set miniSpeed($value:Number):void;
		
		/**
		 *速度 
		 * @return 
		 */		
		function get speed():Number;
		function set speed($value:Number):void;

		/**
		 *加速度 
		 * @return 
		 */		
		function get accelerate():Number;
		function set accelerate($value:Number):void;
		
		/**
		 *计算并返回当前速度
		 * @return
		 */		
		function calculateSpeed():Number;
	}
}