package com.codetemplate.data
{
	import flash.utils.Dictionary;
	
	/**
	 *代码模板数据 
	 * @author yeah
	 */	
	public class CodeTemplateData
	{
		
		/**
		 *模板参数{key:value, key:value, key:value, .....}<br>
		 * key:模板替换的字符 value:替换成的字符
		 */		
		private var templateParam:Object;
		
		/**
		 *放入模板 参数 
		 * @param $replacekey			模板中可替换的key（根据正则过滤后）
		 * @param $value					替换成$value
		 */		
		public function pushTemplateParam($replacekey:String, $value:String):void
		{
			if(!templateParam)
			{
				templateParam = {};
			}
			
			templateParam[$replacekey] = $value;
		}
		
		/**
		 *获取替换值
		 * @param $key 模板中可替换的key（根据正则过滤后）
		 * @return 
		 */		
		public function getTemplateValue($key:String):String
		{
			if(templateParam && $key in templateParam)
			{
				return templateParam[$key];
			}
			return "";
		}
		
		/**
		 *子模板数据列表 
		 */		
		private var children:Dictionary;
		
		/**
		 *设置子模板 参数 
		 * @param $templateID	子模板的id
		 * @param $replacekey		模板中可替换的key（根据正则过滤后）
		 * @param $value				替换成$value
		 */		
		public function setChildTemplateParam($templateID:String, $replacekey:String, $value:String):void
		{
			var data:CodeTemplateData;
			
			if(!children)
			{
				children = new Dictionary();
			}
			
			if($templateID in children)
			{
				data = children[$templateID];
			}
			else
			{
				children[$templateID] = data = new CodeTemplateData();
			}
			
			data.pushTemplateParam($replacekey, $value);
		}
		
		/**
		 *放入子模板 数据 
		 * @param $templateID
		 * @param $data
		 */		
		public function pushChildTemplateParam($templateID:String, $data:CodeTemplateData):void
		{
			if(!children)
			{
				children = new Dictionary();
			}
			
			children[$templateID] = $data;
		}
		
		/**
		 *根据 子模板id获取子模板数据 
		 * @param $templateID	子模板id
		 * @return 
		 */		
		public function getChildTemplateParm($templateID:String):CodeTemplateData
		{
			if(children && $templateID in children)
			{
				return children[$templateID];
			}
			return null;
		}
		
		public function CodeTemplateData()
		{
		}
	}
}