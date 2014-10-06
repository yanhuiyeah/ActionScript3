package com.codetemplate.professional
{
	import com.codetemplate.manager.CodeTemplateID;

	/**
	 *声明 
	 * @author yeah
	 */	
	public class StatementCodeBlock extends ProfessionalCodeBlock
	{
		public function StatementCodeBlock()
		{
			super(CodeTemplateID.STATEMENT_ID);
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