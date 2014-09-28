package com.codeTemplete.core
{
	import com.codeTemplete.data.TempleteCodeData;

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
		 * @param $param	参数:(代码替换数据)
		 * @return 				
		 */		
		function encoder($param:TempleteCodeData):String;
		
		/**
		 *擦除代码 
		 */		
		function clear():void;
	}
}