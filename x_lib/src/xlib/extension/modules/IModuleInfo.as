package xlib.extension.modules
{
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;

	/**
	 * 模块信息接口<br>
	 * 支持路径加载和二进制流加载（二进制流优先）<br>
	 * url用于唯一标志
	 * @author yeah
	 */	
	public interface IModuleInfo extends IEventDispatcher
	{
		/**
		 *模块路径
		 * @return 
		 */		
		function get url():String;
		
		/**
		 *是否加载过（如果true则必须unloadModule后才能使用loadModule） 
		 * @return 
		 */		
		function get loaded():Boolean;
		
		/**
		 *返回module 
		 * @return 
		 */		
		function get module():IModule;
		
		/**
		 *加载模块 
		 * @param $applicationDomain 应用作用域
		 * @param $securityDomain		 安全沙箱
		 * @param $bytes		 				模块二进制流
		 */		
		function loadModule($applicationDomain:ApplicationDomain = null, $securityDomain:SecurityDomain = null, $bytes:ByteArray = null):void;
		
		/**
		 *卸载模块 
		 */		
		function unloadModule():void;
	}
}