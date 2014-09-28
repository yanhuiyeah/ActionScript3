package com.codeTemplete.core
{
	/**
	 *代码块接口 
	 * @author yeah
	 */	
	public interface ICodeBlock
	{
		/**
		 *代码块xml模板<br>
		 */		
		function get templete():XML;
		function set templete($value:XML):void;
		
		/**
		 *获取代码块
		 */		
		function get codeBlock():String;
		
		/**
		 *编写代码
		 * @param $params	参数
		 * @return 				编译后的代码块文本
		 */		
		function encoder($params:Array):String;
		
		/**
		 *擦除代码 
		 */		
		function clear():void;
	}
}