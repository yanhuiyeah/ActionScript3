package com.transcoding.common
{
	import flash.events.IEventDispatcher;

	/**
	 *转码器接口
	 * @author yeah
	 */	
	public interface ITranscoder extends IEventDispatcher
	{
		/**
		 *待转码数据 
		 */		
		function get data():Object;
		function set data($value:Object):void;
		
		/**
		 *获取转码后的数据 
		 */		
		function get transcodeData():Object;
		
		/**
		 *转码 
		 * @param $data 	待转码数据
		 * @return 			转码后的数据
		 */		
		function transcoding($data:Object):Object;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
		
	}
}