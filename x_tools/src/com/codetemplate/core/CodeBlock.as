package com.codetemplate.core
{
	import com.codetemplate.data.CodeTemplateData;
	import com.codetemplate.data.CodeTemplateInfo;
	import com.codetemplate.manager.CodeRegExp;
	import com.core.x_tools_internal;
	
	use namespace x_tools_internal;

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
			
			if(!_tempateInfo)
			{
				_tempateInfo = new CodeTemplateInfo();
			}
			
			_tempateInfo.setInfo(_templete);
			clear();
		}
		
		private var _tempateInfo:CodeTemplateInfo;
		public function get tempateInfo():CodeTemplateInfo
		{
			return _tempateInfo;
		}
		
		private var codeHistory:Array = [];
		private var codeHistoryChanged:Boolean = false;
		private var _codeBlock:String = "";
		
		public function get codeBlock():String
		{
			if(codeHistoryChanged)
			{
				_codeBlock = tempateInfo.header +codeHistory.join(tempateInfo.delim);
				codeHistoryChanged = false;
			}
			return _codeBlock;
		}
		
		public function clear():void
		{
			codeHistory.length = 0;
			_codeBlock = "";
		}
		
		final public function encoder($params:Array):void
		{
			if(!template) return;
			codeHistoryChanged = true;
			codeHistory.push(onEncoder($params));
		}
		
		/**
		 * 具体编码逻辑[子类可以覆盖]
		 * @return 编码后的代码块
		 */		
		protected function onEncoder($params:Array):String
		{
			if(!$params || $params.length < 1) return "";
			
			var code:String = template.valueOf();
			var patterns:Array = code.match(CodeRegExp.TEMPLATE_G);
			
			var len:int = $params.length;
			var value:String;
			for (var i:int = 0; i < patterns.length; i++) 
			{
				value = patterns[i].toString().replace(CodeRegExp.TEMPLATE_SIGN, "");
				value = len > i ? template2code(value, $params[i]):"";
				code = replace(code, value);
			}
			return code;
		}
		
		/**
		 *模板转换成代码
		 * @param $param
		 */		
		protected function template2code($templateText:String, $param:Object):String
		{
			if(!$param) return "";
			return $param.toString();
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
	}
}