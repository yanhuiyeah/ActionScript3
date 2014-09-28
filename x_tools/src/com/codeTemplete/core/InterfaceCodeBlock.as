package com.codeTemplete.core
{
	/**
	 *接口代码块 
	 * @author yeah
	 */	
	public class InterfaceCodeBlock extends CodeBlock
	{
		public function InterfaceCodeBlock()
		{
			super();
		}
		
		override protected function onEncoder($params:Array):String
		{
			if(!templete) return "";
			var code:String = templete.valueOf();
			
			for (var i:int = 0; i < $params.length; i++) 
			{
				code = code.replace("/\$\{([a-z]*.([a-z])*)\}/", $params[i].toString())
			}
			
			return code;
		}
	}
}