package com.encoder.data
{
	import flash.display.BitmapData;
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
		 *二进制流（xml、txt等文本文件）或者 图片BitmapData（png、jpg等文件）
		 */		
		public var data:Object;
		
		/**
		 *销毁 
		 */		
		public function destroy():void
		{
			if(data)
			{
				if(data is ByteArray)
				{
					data.clear();
				}
				else if(data is BitmapData)
				{
					BitmapData(data).dispose();
				}
				data = null;
			}
		}
		
		public function FileData()
		{
		}
	}
}