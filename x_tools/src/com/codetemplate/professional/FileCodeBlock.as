package com.codetemplate.professional
{
	import com.codetemplate.manager.CodeTemplateID;

	/**
	 *文件代码快 
	 * @author yeah
	 */	
	public class FileCodeBlock extends ProfessionalCodeBlock
	{
		public function FileCodeBlock()
		{
			super(CodeTemplateID.FILE_ID);
		}
		
		public function changePackage($pakage:String):void
		{
			
		}
		
		public function changeName($name:String):void
		{
			//类名和构造函数
		}
		
		public function changeModifiers($modifiers:String):void
		{
			
		}
		
		public function changeType($type:String):void
		{
			
		}
		
		public function changeExtends($extends:String):void
		{
			
		}
		
		public function addImplements($param:String):void
		{
			
		}
		
		public function addImport($param:Array):void
		{
			
		}
	}
}