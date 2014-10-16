package xlib.framework.events
{
	import flash.events.Event;
	
	/**
	 *代替 ENTER_FRAME事件 并提供与上一次dispatch此事件的间隔（毫秒）
	 * @author yeah
	 */	
	public class TickEvent extends Event
	{
		/**
		 *相当于ENTER_FRAME事件 
		 */		
		public static const FRAME_TICK:String = "frame_tick";
		
		/**
		 * 与上一次dispatch FrameTickEvent事件的间隔（毫秒）
		 */		
		public var interval:int;
		
		public function TickEvent(type:String, $interval:int , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.interval = $interval;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new TickEvent(TickEvent.FRAME_TICK , this.interval);
		}
	}
}
