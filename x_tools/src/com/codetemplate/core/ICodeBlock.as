package com.codetemplate.core
{
	import com.codetemplate.data.CodeTemplateData;
	import com.codetemplate.data.CodeTemplateInfo;

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
		 *获取模板信息 
		 */		
		function get tempateInfo():CodeTemplateInfo;
		
		/**
		 *获取代码块 
		 */		
		function get codeBlock():String;
		
		/**
		 *编码
		 * @param $params	  参数数组
		 */		
		function encoder($params:Array):void;
		
		/**
		 *擦除代码 
		 */		
		function clear():void;
	}
}