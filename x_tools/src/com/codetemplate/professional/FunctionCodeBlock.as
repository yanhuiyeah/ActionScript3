package com.codetemplate.professional
{
	import com.codetemplate.manager.CodeTemplateID;

	/**
	 *函数代码块<br> 
	 * 调用encoder([参数名称, 参数类型, 参数默认值])<br>
	 * @example 实例
	 * <listing>
	 * encoder(["x_lib", "private", "function" + i, "", "void", "i = " + i + ";"]);
	 * </listing>
	 * @author yeah
	 */	
	public class FunctionCodeBlock extends ProfessionalCodeBlock
	{
		public function FunctionCodeBlock()
		{
			super(CodeTemplateID.FUNCTION_ID);
		}
		
		override protected function template2code($templateText:String, $param:Object):String
		{
			var code:String = super.template2code($templateText, $param);
			if($templateText == "return_type" && code.length > 0)
			{
				return ":" + $param.toString();
			}
			
			return code;
		}
	}
}