package com.core
{
	import com.data.PluginData;
	
	import flash.utils.Dictionary;

	/**
	 *插件容器 
	 * @author yeah
	 */	
	public interface IPluginContainer
	{
		/**
		 *安装插件 
		 * @param $tools				工具插件
		 * @param $exhibition		展示插件
		 */		
		function instanllPlugins($tools:IPlugin, $exhibition:IExhibitionPlugin = null):void;
		
		/**
		 *初始化插件列表 
		 * @param $vect
		 */		
		function initPluginList($dic:Dictionary):void;
	}
}