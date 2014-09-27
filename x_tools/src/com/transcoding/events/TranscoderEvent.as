package com.transcoding.events
{
	import flash.events.Event;
	
	/**
	 *转码器Event 
	 * @author yeah
	 */	
	public class TranscoderEvent extends Event
	{
		/**
		 *转码完成 
		 */		
		public static const COMPLETE:String = "complete";
		
		/**
		 *待转码数据 
		 */		
		public var data:Object;
		
		/**
		 *转码后的数据 
		 */		
		public var transcodeData:Object;
		
		public function TranscoderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 *创建一个 TranscoderEvent
		 * @param $type
		 * @param $transcodeData
		 * @param $data
		 * @param bubbles
		 * @param cancelable
		 */		
		public static function create($type:String, $transcodeData:Object = null, $data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false):TranscoderEvent
		{
			var e:TranscoderEvent = new TranscoderEvent($type, bubbles, cancelable);
			e.transcodeData = $transcodeData;
			e.data = $data;
			return e;
		}
	}
}