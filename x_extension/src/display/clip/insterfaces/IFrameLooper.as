package display.clip.insterfaces
{
	import flash.events.IEventDispatcher;

	public interface IFrameLooper extends IEventDispatcher
	{
		
		/**
		 *自动挂起，当处于休眠状态时是否自动挂起（等待唤醒后再进行计算） 
		 * @return 
		 */		
		function get autoSuspend():Boolean;
		function set autoSuspend($value:Boolean):void;
		
		/**
		 *是否处于挂起状态 
		 * @return 
		 */		
		function get suspended():Boolean;
		
		/**
		 *一个循环经过的帧数 ；0表示一个循环有无限帧数
		 * @return 
		 */		
		function get loopFrames():int;
		function set loopFrames($value:int):void;
		
		/**
		 *循环重复总次数<br> 
		 * -1无线重复;默认值= -1
		 */		
		function get repeat():int;
		function set repeat($value:int):void;
		
		/**
		 *当前循环次数 
		 * @return 
		 */		
		function get repeatTimes():int;
		
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
		 *当前帧在循环中所在的索引
		 * @return 
		 */		
		function get frameIndex():int;

		/**
		 *是否正在播放 
		 * @return 
		 */		
		function get isPlaying():Boolean;
		
		/**
		 *从指定帧开始播放；默认值0，表示第一帧
		 * @param $frameIndex	指定帧
		 */		
		function gotoAndPlay($frameIndex:int = 0):void;
		
		/**
		 *将播放到指定帧并停在那里；默认值-1，表示最当前帧
		 * @param $frameIndex	指定帧
		 */		
		function gotoAndStop($frameIndex:int = -1):void;
		
		/**
		 *暂停 
		 */		
		function pause():void;

		/**
		 *恢复播放 
		 */		
		function resume():void;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
		
	}
}