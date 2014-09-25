package com.encoder.data
{
	import flash.utils.ByteArray;

	/**
	 *文件数据 
	 * @author yeah
	 */	
	public class FileData
	{
		/**
		 *文件索引 
		 */		
		public var index:int;
		
		/**
		 *名称 
		 */		
		public var name:String;
		
		/**
		 *扩展名 
		 */		
		public var extension:String;
		
		/**
		 *二进制流 
		 */		
		public var bytes:ByteArray;
		
		/**
		 *销毁 
		 */		
		public function destroy():void
		{
			if(bytes)
			{
				bytes.clear();
				bytes = null;
			}
		}
		
		public function FileData()
		{
		}
	}
}