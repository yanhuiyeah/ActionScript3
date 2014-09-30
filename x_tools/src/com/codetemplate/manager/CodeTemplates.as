package com.codetemplate.manager
{
	import flash.utils.Dictionary;
	
	import mx.core.ByteArrayAsset;
	
	/**
	 *代码模板 
	 * @author yeah
	 */	
	public class CodeTemplates
	{
		/**
		 *当前语言 
		 */		
		public static var currentLanguage:String = "ActionScript3";
		
		/***ActionScript3代码模板表*/		
		[Embed("../assets/code_templates/actionscript3_templates.xml", mimeType="application/octet-stream")]
		private var actionscript3_templates:Class;
		
		/**
		 *代码模板字典
		 */		
		private var codeTempleteDic:Dictionary;
		
		/**
		 *注册模板配置文件 <br>
		 * 储存格式：Dictionary[$language#$id] = $templete
		 * @param $id				模板id
		 * @param $templete	模板xml	
		 * @param $language	模板语言
		 * @see ClassCodeID
		 */		
		public function regiterCodeTemplete($id:String, $templete:XML, $language:String):void
		{
			var key:String = $language + "#" + $id;
			codeTempleteDic[key] = $templete;
		}
		
		/**
		 *获取代码模板xml 
		 * @param $id				模板id
		 * @param $language	模板语言
		 * @return 					代码模板xml
		 * @see ClassCodeID
		 */		
		public function getCodeTemplete($id:String, $language:String = null):XML
		{
			if(!$language)
			{
				$language = currentLanguage;
			}
			
			var key:String = $language + "#" + $id;
			
			if(key in codeTempleteDic)
			{
				return codeTempleteDic[key];
			}
			return null;
		}
		
		/**
		 *解析模版文件 
		 * @param $templetes	代码模板xml（为拆分的）
		 * @return 					模板语言
		 */		
		private function paseTemplete($templetes:XML):String
		{
			var language:String = $templetes.@language;
			var templets:XMLList = $templetes.template as XMLList;
			for each(var templete:XML in templets)
			{
				regiterCodeTemplete(templete.@id, templete, language);
			}
			return language;
		}
		
		/**
		 *初始化 
		 */		
		private function int():void
		{
			currentLanguage = paseTemplete(new XML(new actionscript3_templates()));
			this.actionscript3_templates = null;
		}

		//====================================
		/**
		 *唯一实例 
		 * @return 
		 */		
		public static function get instance():CodeTemplates
		{
			if(!_instance)
			{
				_instance = new CodeTemplates();
			}
			return _instance;
		}

		private static var _instance:CodeTemplates;
		
		public function CodeTemplates()
		{
			codeTempleteDic = new Dictionary();
			int();
		}
	}
}