package com.file.data
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
		 *文件路径（编码格式C:/Documents%20and%20Settings/turing/My%20Documents） 
		 */		
		public var url:String;
		
		/**
		 *文件路径（系统格式C:\Documents and Settings\turing\My Documents） 
		 */		
		public var nativePath:String;
		
		private var _data:Object;

		/**
		 *二进制流（xml、txt等文本文件）或者 图片BitmapData（png、jpg等文件）
		 */
		public function get data():Object
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(_data == value) return;
			destroy();
			_data = value;
		}

		
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