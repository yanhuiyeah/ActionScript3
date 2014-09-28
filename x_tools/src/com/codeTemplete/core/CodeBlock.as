package com.codeTemplete.core
{
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
		
		final public function encoder($params:Array):String
		{
			_codeBlock = onEncoder($params);
			return _codeBlock;
		}
		
		/**
		 * 具体编码逻辑[抽象方法，子类必须覆盖]
		 * @return 编码后的代码块
		 */		
		protected function onEncoder($params:Array):String
		{
			throw new Error("onEncoder是抽象方法，子类必须覆盖!");
		}
		
	}
}