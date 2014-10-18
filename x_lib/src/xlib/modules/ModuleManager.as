package xlib.modules
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import xlib.framework.core.LazyDispatcher;
	
	/**
	 *module管理器 
	 * @author yeah
	 */	
	public class ModuleManager extends LazyDispatcher implements IModuleManager
	{
		
		/**
		 *module字典
		 */		
		private var modules:Dictionary = new Dictionary(true);
		
		public function ModuleManager($dispatcher:IEventDispatcher=null)
		{
			super($dispatcher);
		}
		
		public function getModule($url:String):IModuleInfo
		{
			var moduleInfo:IModuleInfo;
			for(var obj:Object in modules)
			{
				moduleInfo = obj as IModuleInfo;
				if(moduleInfo && moduleInfo.url == $url)
				{
					break;
				}
			}
			
			
			if(!moduleInfo || moduleInfo.url != $url)
			{
				moduleInfo = new ModuleInfo($url);
				modules[moduleInfo] = $url;
			}
			
			return moduleInfo;
		}
		
		private static var _instance:ModuleManager;

		/**
		 *唯一实例 
		 */
		public static function get instance():ModuleManager
		{
			if(!_instance)
			{
				_instance = new ModuleManager();
			}
			return _instance;
		}

		
	}
}