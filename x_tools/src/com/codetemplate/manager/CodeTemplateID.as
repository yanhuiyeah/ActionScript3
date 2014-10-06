package com.codetemplate.manager
{
	
	/**
	 *代码块模板id<br>
	 * @author 
	 */	
	public class CodeTemplateID
	{
		
		/**file模板id*/
		public static const FILE_ID:String = "file";
		
		/**import导入包模板id*/
		public static const IMPORT_ID:String = "import";
		
		/**extends继承类模板id*/
		public static const EXTENDS_ID:String = "extends";
		
		/**implements实现接口模板id*/
		public static const IMPLEMENTS_ID:String = "implements";
		
		/**params模板id*/
		public static const PARAMS_ID:String = "params";
		
		/**构造函数模板id*/
		public static const CONSTRUCTOR_ID:String = "constructor";
		
		/**function模板id*/
		public static const FUNCTION_ID:String = "function";
		
		/**变量声明模板id*/
		public static const STATEMENT_ID:String = "statement";
		
		/**getter模板id*/
		public static const GETTER_ID:String = "getter";
		
		/**setter模板id*/
		public static const SETTER_ID:String = "setter";
		
		/**fore模板id*/
		public static const FORE_ID:String = "fore";
		
		/**fori模板id*/
		public static const FORI_ID:String = "fori";
		
		/**switch模板id*/
		public static const SWITCH_ID:String = "switch";
		
		/**do模板id*/
		public static const DO_ID:String = "do";
		
		/**if模板id*/
		public static const IF_ID:String = "if";
		
		/**tryCatch模板id*/
		public static const TRYCATCH_ID:String = "tryCatch";
		
		public function CodeTemplateID()
		{
			throw new Error("静态类不能被实例化!");
		}
	}
}