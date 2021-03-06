package com.codetemplate.professional
{
	import com.codetemplate.data.CodeTemplateData;
	import com.codetemplate.manager.CodeTemplateID;

	/**
	 *参数代码块<br> 
	 * 调用encoder([参数名称, 参数类型, 参数默认值])<br>
	 * @example 实例
	 * <listing>
	 * encoder(["test", "String", "a"]);	encoder(["test", "String", "null"]); encoder(["test", "String"]);
	 * </listing>
	 * @author yeah
	 */	
	public class ParamCodeBlock extends ProfessionalCodeBlock
	{
		public function ParamCodeBlock()
		{
			super(CodeTemplateID.PARAMS_ID);
		}
		
		override protected function template2code($templateText:String, $param:Object):String
		{
			var code:String = super.template2code($templateText, $param);
			if($templateText == "value" && code.length > 0)
			{
				return " = " + $param.toString();
			}
			
			return code;
		}
	}
}