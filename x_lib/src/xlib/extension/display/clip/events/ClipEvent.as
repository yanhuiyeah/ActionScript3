package xlib.extension.display.clip.events
{
	import flash.events.Event;
	
	/**
	 *clip 事件 
	 * @author yeah
	 */	
	public class ClipEvent extends Event
	{
		/**
		 *每一帧派发的事件 
		 */		
		public static const FRAME:String = "frame";
		
		/**
		 *播放结束 （repeat == 0）
		 */		
		public static const COMPLETE:String = "complete";
		
		/**
		 *完成一个循环（一个序列帧从头到尾）
		 */		
		public static const REPEAT:String = "repeat";
		
		/**
		 * 数据准备完成
		 */		
		public static const FRAME_DATA_IS_READY:String = "frame_data_is_ready";
		
		/**
		 *附带的数据 
		 */		
		public var data:Object;
		
		public function ClipEvent(type:String, $data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = $data;
		}
	}
}