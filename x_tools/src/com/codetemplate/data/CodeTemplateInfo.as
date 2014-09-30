package com.codetemplate.data
{
	import com.core.x_tools_internal;
	
	/**
	 *代码模板信息 
	 * @author yeah
	 */	
	public class CodeTemplateInfo
	{
		public function CodeTemplateInfo()
		{
		}
		
		private var _header:String = "";

		/**
		 *头信息
		 */
		public function get header():String
		{
			return _header;
		}

		private var _delim:String = "";
		/**
		 * 每次重复的间隔符
		 */		
		public function get delim():String
		{
			return _delim;
		}
		
		/**
		 * 设置模板信息
		 * @param $template
		 */		
		x_tools_internal function setInfo($template:XML):void
		{
			if($template)
			{
				_header = $template.@header;
				_delim = $template.@delim;
			}
			else
			{
				reset();
			}
		}
		
		/**
		 *重置 
		 */		
		private function reset():void
		{
			_delim = "";
			_header = "";
		}
	}
}