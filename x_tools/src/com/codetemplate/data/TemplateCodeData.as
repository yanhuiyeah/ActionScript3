package com.codetemplate.data
{
	/**
	 *模板代码数据 
	 * @author yeah
	 */	
	public class TemplateCodeData
	{
		
		/**
		 * 名称
		 */		
		public var name:String;
		
		/**
		 * 类型
		 */		
		public var type:String;
		
		private var _value:String = "";

		/**
		 *默认值
		 */
		public function get value():String
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value($value:String):void
		{
			_value = " = " + $value;
		}
		
		/**
		 *数据列表(可以是任意格式) 
		 */		
		public var array:Array;
		
		
		public function TemplateCodeData()
		{
		}
	}
}