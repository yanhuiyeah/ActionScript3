package com.core
{
	import com.data.PluginData;
	
	import flash.utils.Dictionary;

	/**
	 *工具manager
	 * @author yeah
	 */	
	public class ToolsManager
	{
		/**
		 *插件容器 
		 */		
		private var container:IPluginContainer;
		
		/**
		 *插件集合 
		 */		
		private var pluginDic:Dictionary = new Dictionary();
		
		
		/**
		 *注册 插件容器
		 * @param $container
		 */		
		public function registerPluginsContainer($container:IPluginContainer):void
		{
			this.container = $container;
		}
		
		/**
		 *注册插件 
		 * @param $tools
		 * @param $exhbition
		 */		
		public function registerPlugins($tools:IPlugin, $exhbition:IExhibitionPlugin = null):void
		{
			if(!container)
			{
				x_Log.show("请先注册插件容器--ToolsManager.instance.registerPluginsContainer(插件容器)");
				return;
			}
			else if(!$tools)
			{
				x_Log.show("工具插件不能为空");
				return;
			}
			
			var pd:PluginData = new PluginData();
			pd.tools = $tools;
			pd.exhibition = $exhbition;
			pluginDic[pd.tools.pluginID] = pd;
		}
		
		/**
		 *开始执行 
		 */		
		public function initPluginList():void
		{
			if(!container)
			{
				x_Log.show("请先注册插件容器--ToolsManager.instance.registerPluginsContainer(插件容器)");
				return;
			}
			
			container.initPluginList(pluginDic);
			usePlugin("CodeBlockPlugin");
		}
		
		/**
		 *使用插件 
		 * @param $pluginID
		 */		
		public function usePlugin($pluginID:String):void
		{
			var pd:PluginData = pluginDic[$pluginID];
			container.instanllPlugins(pd.tools, pd.exhibition);
		}

		/**
		 *ToolsManager唯一实例 
		 * @return 
		 */		
		public static function get instance():ToolsManager
		{
			if(!_instance)
			{
				_instance = new ToolsManager();
			}
			return _instance;
		}
		private static var _instance:ToolsManager;
		
		
		
		public function ToolsManager()
		{
		}
	}
}