package com.codetemplate.core
{
	import com.codetemplate.data.TemplateCodeData;
	import com.codetemplate.manager.CodeTemplateID;

	/**
	 *参数代码块 
	 * @author yeah
	 */	
	public class ParamCodeBlock extends CodeBlock
	{
		public function ParamCodeBlock()
		{
			super();
		}
		
		override protected function onEncoder($param:TemplateCodeData):String
		{
			var templateCode:String = template.valueOf();
			var code:String = "";
			if($param.array)
			{
				var array:Array = $param.array;
				while(array.length > 1)
				{
					code += replaceParam(templateCode, array.shift()) + ",";
				}
				code += replaceParam(templateCode, array.shift());
			}
			else
			{
				code += replaceParam(templateCode, $param);
			}
			
			return code;
		}
		
		/**
		 *替换参数模板 
		 * @param $code
		 * @param $param
		 * @return 
		 */		
		private function replaceParam($code:String, $param:TemplateCodeData):String
		{
			$code = replace($code, $param.name);
			$code = replace($code, $param.type);
			$code = replace($code, $param.value);
			return $code;
		}
		
		override protected function checkTemplate():Boolean
		{
//			if(templete.@name == CodeTemplateID.PARAM_TEMPLETE) return true;
			return false;
		}
	}
}