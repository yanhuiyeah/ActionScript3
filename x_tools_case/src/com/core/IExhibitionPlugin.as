package com.core
{
	/**
	 *展示插件
	 * @author yeah
	 */	
	public interface IExhibitionPlugin extends IPlugin
	{
		/**
		 *进度 
		 * @param $phase	当前阶段
		 * @param $param	参数
		 */		
		function progress($phase:String, $param:Array = null):void;
	}
}