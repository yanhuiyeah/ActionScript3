package com.codetemplate.core
{
	import com.codetemplate.data.TemplateCodeData;

	/**
	 *代码块接口 
	 * @author yeah
	 */	
	public interface ICodeBlock
	{
		/**
		 *代码块xml模板<br>
		 */		
		function get template():XML;
		function set template($value:XML):void;
		
		/**
		 *获取代码块
		 */		
		function get codeBlock():String;
		
		/**
		 *编写代码
		 * @param $param	参数:(代码替换数据)
		 * @return 				
		 */		
		function encoder($param:TemplateCodeData):String;
		
		/**
		 *擦除代码 
		 */		
		function clear():void;
	}
}