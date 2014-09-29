package com.codetemplate.core
{
	import com.codetemplate.data.TemplateCodeData;

	/**
	 *代码模板基类 
	 * @author yeah
	 */	
	public class CodeBlock implements ICodeBlock
	{
		public function CodeBlock()
		{
		}
		
		private var _templete:XML;
		public function get template():XML
		{
			return _templete;
		}
		
		public function set template($value:XML):void
		{
			if(this._templete == $value) return;
			this._templete = $value;
			clear();
		}
		
		private var _codeBlock:String = "";
		public function get codeBlock():String
		{
			return _codeBlock;
		}
		
		public function clear():void
		{
			_codeBlock = "";
		}
		
		final public function encoder($param:TemplateCodeData):String
		{
			if(!template) return "";
			if(!checkTemplate())
			{
				throw new Error("模板类型"+template.@name+"不适用于当前代码块!");
			}
			_codeBlock = onEncoder($param);
			return _codeBlock;
		}
		
		/**
		 * 具体编码逻辑[子类可以覆盖]
		 * @return 编码后的代码块
		 */		
		protected function onEncoder($param:TemplateCodeData):String
		{
			if(!$param || !$param.array) return "";
			
			var code:String = template.valueOf();
			var dataList:Array = $param.array;
			var len:int = dataList.length;
			for (var i:int = 0; i < len; i++) 
			{
				code = replace(code, dataList[i]);
			}
			
			return code;
		}
		
		/**
		 *替换模板代码 
		 * @param $sourceCode
		 * @param $code
		 * @return 
		 */		
		protected function replace($sourceCode:String, $code:String):String
		{
			return $sourceCode.replace(/(\$\{.+?\})/, $code);
		}
		
		/**
		 *检测模板是否适用于当前 
		 */		
		protected function checkTemplate():Boolean
		{
			return true;	
		}
		
	}
}