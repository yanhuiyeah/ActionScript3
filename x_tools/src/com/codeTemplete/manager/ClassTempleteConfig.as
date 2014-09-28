package com.codeTemplete.manager
{
	import flash.utils.Dictionary;
	
	import mx.core.ByteArrayAsset;
	
	/**
	 *模板配置数据 
	 * @author yeah
	 */	
	public class ClassTempleteConfig
	{
		
		/**
		 *默认代码模版
		 */		
		[Embed("../assets/templetes/as/default_code_templates.xml", mimeType="application/octet-stream")]
		private var default_code_templates:Class;
		
		/**
		 *默认文件模版 
		 */		
		[Embed("../assets/templetes/as/default_filetemplates.xml", mimeType="application/octet-stream")]
		private var default_file_templates:Class;
		
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
			trace($key);
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
		
		/**
		 *解析模版文件 
		 * @param $xml
		 */		
		private function paseTemplete($xml:XML):void
		{
			var xmlList:XMLList = $xml.template as XMLList;
			for each(var xml:XML in xmlList)
			{
				regiterTempleteConfig(xml.@name, xml);
			}
		}
		
		/**
		 *初始化 
		 */		
		private function int():void
		{
			var xml:XML = new XML(new default_code_templates());  
			paseTemplete(xml);
			
			xml = new XML(new default_file_templates());  
			paseTemplete(xml);
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
			int();
		}
	}
}