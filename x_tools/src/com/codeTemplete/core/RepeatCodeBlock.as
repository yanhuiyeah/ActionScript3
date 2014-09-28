package com.codeTemplete.core
{
	import com.codeTemplete.data.TempleteCodeData;

	/**
	 *重复的代码块<br>
	 * @author yeah
	 */	
	public class RepeatCodeBlock extends CodeBlock
	{
		/**换行*/
		private static const NEW_LINE_CODE:String = "&#13;";
		
		private var _delimiter:String = "";
		/**
		 *间隔符号 (默认:"")<br>
		 * 无符号(比如重复的方法块)--""<br>
		 * 逗号(比如重复的参数块)--","<br>
		 * 分号(比如重复的变量声明)--";"<br>
		 * @return 
		 */		
		public function get delimiter():String
		{
			return _delimiter;
		}

		public function set delimiter(value:String):void
		{
			_delimiter = value;
		}
		
		private var _isVertical:Boolean = true; 

		/**
		 *是否是垂直重复(默认true)<br>
		 * true:比如方法体,变量声明<br> 
		 * false:比如方法参数<br> 
		 */
		public function get isVertical():Boolean
		{
			return _isVertical;
		}

		/**
		 * @private
		 */
		public function set isVertical(value:Boolean):void
		{
			_isVertical = value;
		}

		public function RepeatCodeBlock()
		{
			super();
		}
	}
}