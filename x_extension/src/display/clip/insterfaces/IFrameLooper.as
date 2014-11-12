package display.clip.insterfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 *可循环的元素 
	 * @author yeah
	 */	
	public interface IFrameLooper extends IEventDispatcher
	{
		/**
		 *帧率 如果不设置则默认设为 stage.frameRate;<br>
		 * 如果设置了frameDuration 设置此参数无效
		 */		
		function get frameRate():uint;
		function set frameRate($value:uint):void;
		
		/**
		 *每帧播放时间 (毫秒) 如果不设置则根据frameRate计算;<br>
		 * 设置了此参数则 设置的frameRate无效<br>
		 * 设置此参数后如果想frameRate生效请设置frameDuration=0
		 */		
		function get frameDuration():uint;
		function set frameDuration($value:uint):void;
		
		/**
		 *循环播放次数<br> 
		 * -1无线重复;默认值= -1<br>
		 */		
		function get repeat():int;
		function set repeat($value:int):void;
		
		/***已经循环的次数*/		
		function get repeatTimes():int;
		
		/**当前帧索引*/
		function get frameIndex():int;
		function set frameIndex($value:int):void;
		
		/***当前运行状态*/		
		function get isRunning():Boolean;
		
		/***销毁**/		
		function destroy():void;
	}
}