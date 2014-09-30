package com.codetemplate.manager
{
	/**
	 *正则
	 * @author yeah
	 */	
	public class CodeRegExp
	{
		
		/**
		 *模板对应的正则 （匹配1个）
		 */		
		public static const TEMPLATE:RegExp = /(\$\{.+?\})/;
		
		/**
		 *模板对应的正则 (全部匹配)
		 */		
		public static const TEMPLATE_G:RegExp = /(\$\{.+?\})/g;
		
		/**
		 *匹配的符号 
		 */		
		public static const TEMPLATE_SIGN:RegExp = /[\$\{\}]/g;
		
		public function CodeRegExp()
		{
		}
	}
}