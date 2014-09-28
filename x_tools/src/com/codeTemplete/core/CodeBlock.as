package com.codeTemplete.core
{
	import com.codeTemplete.data.TempleteCodeData;

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
		public function get templete():XML
		{
			return _templete;
		}
		
		public function set templete($value:XML):void
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
		
		final public function encoder($param:TempleteCodeData):String
		{
			if(!templete) return "";
			if(!checkTemplete())
			{
				throw new Error("模板类型"+templete.@name+"不适用于当前代码块!");
			}
			_codeBlock = onEncoder($param);
			return _codeBlock;
		}
		
		/**
		 * 具体编码逻辑[子类可以覆盖]
		 * @return 编码后的代码块
		 */		
		protected function onEncoder($param:TempleteCodeData):String
		{
			if(!$param || !$param.array) return "";
			
			var code:String = templete.valueOf();
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
		protected function checkTemplete():Boolean
		{
			return true;	
		}
		
	}
}