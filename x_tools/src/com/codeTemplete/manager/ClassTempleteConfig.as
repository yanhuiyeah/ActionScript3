package com.codeTemplete.manager
{
	import flash.utils.Dictionary;
	
	/**
	 *模板配置数据 
	 * @author yeah
	 */	
	public class ClassTempleteConfig
	{
		/**
		 *模板配置 
		 */		
		private var templeteConfig:Dictionary;
		
		/**
		 *注册模板配置文件 
		 * @param $key
		 * @param $config
		 */		
		public function regiterTempleteConfig($key:String, $config:XML):void
		{
			templeteConfig[$key] = $config;
		}
		
		/**
		 *获取模板xml文件 
		 * @param $key
		 * @return 
		 */		
		public function getTempleteConfig($key:String):XML
		{
			if($key in templeteConfig)
			{
				return templeteConfig[$key];
			}
			else
			{
				//loader
			}
			return null;
		}
		
		
		

		//====================================
		/**
		 *唯一实例 
		 * @return 
		 */		
		public static function get instance():ClassTempleteConfig
		{
			if(!_instance)
			{
				_instance = new ClassTempleteConfig();
			}
			return _instance;
		}

		private static var _instance:ClassTempleteConfig;
		
		public function ClassTempleteConfig()
		{
			templeteConfig = new Dictionary();
		}
	}
}