package com.transcoding.classgroup
{
	import com.transcoding.common.Transcoder;
	
	import flash.events.IEventDispatcher;
	
	/**
	 *XML配置转换成类文本
	 * @author yeah
	 */	
	public class ClassXML2Class extends Transcoder
	{
		public function ClassXML2Class(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function set data($value:Object):void
		{
			super.data = $value;
		}
		
		override public function transcoding($data:Object):Object
		{
			if(!checkDataType($data))
			{
				this._transcodeData = null;
				return _transcodeData;
			}
			
			var xml:XML = XML($data);
			var str:String = xml.toString();
			trace(str);
			
			return _transcodeData;
		}
		
		/**
		 *检测数据类型 
		 * @param $data
		 * @return
		 */		
		private function checkDataType($data:Object):Boolean
		{
			if($data && $data is XML) return true;
			trace("本转码器j仅支持XML类型! $data是:", typeof($data));
			return false;
		}
	}
}