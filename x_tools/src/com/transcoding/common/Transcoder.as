package com.transcoding.common
{
	import com.transcoding.events.TranscoderEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *转码完成的事件 
	 */	
	[Event(name="complete", type="com.transcoding.events.TranscoderEvent")]
	
	/**
	 *转码器 基类
	 * @author yeah
	 */	
	public class Transcoder extends EventDispatcher implements ITranscoder
	{
		public function Transcoder(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var _data:Object;
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data($value:Object):void
		{
			if(this._data == $value) return;
			this._data = $value;
			transcoding(data);
		}
		
		protected var _transcodeData:Object;
		public function get transcodeData():Object
		{
			return _transcodeData;
		}
		
		/**
		 *@internal 		[子类重写此方法实现自己的转码逻辑]
		 *@inheritDoc 
		 */		
		public function transcoding($data:Object):Object
		{
			onDispatch(TranscoderEvent.COMPLETE, transcodeData, data);
			return transcodeData;
		}
		
		public function destroy():void
		{
			this.data = null;
			this._transcodeData = null;
		}
		
		/**
		 *派发事件 
		 * @param $type 					事件类型
		 * @param $transcodeData	转码后的数据
		 * @param $data					源数据（未转码）			
		 */		
		protected function onDispatch($type:String, $transcodeData:Object = null, $data:Object = null):void
		{
			this.dispatchEvent(TranscoderEvent.create($type, transcodeData, data));
		}
	}
}