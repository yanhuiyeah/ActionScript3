package com.codetemplate.professional
{
	import com.codetemplate.core.CodeBlock;
	import com.codetemplate.data.CodeTemplateData;
	import com.codetemplate.manager.CodeTemplates;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 *专业的代码块基类 （比如：专门负责参数的 专门负责 导入包的 等等）-- 抽象类
	 * @author yeah
	 */	
	public class ProfessionalCodeBlock extends CodeBlock
	{
		
		[Deprecated(message="set template(), 已经弃用!", replacement="彻底弃用，无代替", since="since")]
		override public function set template($value:XML):void
		{
			throw new Error("set template(), 已经弃用!");
		}
		
		public function ProfessionalCodeBlock()
		{
			super.template = CodeTemplates.instance.getCodeTemplete(getTemplateID());
		}
		
		protected function getTemplateID():String
		{
			throw new IllegalOperationError("抽象方法必须覆盖");
		}
	}
}