package com.core
{
	import flash.display.DisplayObjectContainer;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	/**
	 *工具插件接口 
	 * @author yeah
	 */	
	public interface IPlugin extends IVisualElement
	{
		
		/**
		 *插件id
		 * @return 
		 */		
		function get pluginID():String;
		
		/**
		 *插件名称 
		 * @return 
		 */		
		function get pluginName():String;
		
		/**
		 *数据 
		 */		
		function get data():Object;
		function set data($value:Object):void;
		
		/**
		 *是否已经安装了 
		 */		
		function get installed():Boolean;
		
		/**
		 *安装 
		 * @param $parent			父容器
		 */		
		function install($parent:IVisualElementContainer):void;
		
		/**
		 *卸载 
		 */		
		function uninstall():void;
	}
}