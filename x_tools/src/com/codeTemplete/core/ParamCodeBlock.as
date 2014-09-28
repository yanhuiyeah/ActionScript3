package com.codeTemplete.core
{
	import com.codeTemplete.data.TempleteCodeData;
	import com.codeTemplete.manager.ClassCodeKey;

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
		
		override protected function onEncoder($param:TempleteCodeData):String
		{
			var templateCode:String = templete.valueOf();
			var code:String = "";
			if($param.array)
			{
				var array:Array = $param.array;
				while(array.length > 1)
				{
					code += replaceParam(templateCode, array.shift()) + ", ";
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
		private function replaceParam($code:String, $param:TempleteCodeData):String
		{
			$code = replace($code, $param.name);
			$code = replace($code, $param.type);
			$code = replace($code, $param.value);
			return $code;
		}
		
		override protected function checkTemplete():Boolean
		{
			if(templete.@name == ClassCodeKey.PARAM_TEMPLETE) return true;
			return false;
		}
	}
}