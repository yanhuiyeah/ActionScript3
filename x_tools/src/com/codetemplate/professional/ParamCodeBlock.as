package com.codetemplate.professional
{
	import com.codetemplate.data.CodeTemplateData;
	import com.codetemplate.manager.CodeTemplateID;

	/**
	 *参数代码块 
	 * @author yeah
	 */	
	public class ParamCodeBlock extends ProfessionalCodeBlock
	{
		override protected function getTemplateID():String
		{
			return CodeTemplateID.PARAMS_ID;
		}
		
		public function ParamCodeBlock()
		{
			super();
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