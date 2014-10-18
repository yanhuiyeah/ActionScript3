package xlib.modules
{
	/**
	 *模块管理器 
	 * @author yeah
	 */	
	public interface IModuleManager
	{
		/**
		 *获取模块 
		 * @param $url
		 * @return 
		 */		
		function getModule($url:String):IModuleInfo;		
	}
}