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
		
		
		
		public function ProfessionalCodeBlock($templateID:String = null)
		{
			this.templateID = $templateID;
			super.template = CodeTemplates.instance.getCodeTemplete(templateID == null ? getTemplateID() : templateID);
		}
		
		/**代码模版id*/
		private var templateID:String;
		
		protected function getTemplateID():String
		{
			if(!templateID)
			{
				throw new IllegalOperationError("必须重写getTemplateID()方法或者通过构造函数确定模版id");
			}
			return templateID;
		}
	}
}