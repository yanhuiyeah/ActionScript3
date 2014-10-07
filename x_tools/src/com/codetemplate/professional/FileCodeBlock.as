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
		
		private var codeChanged:Boolean = true;

		/**包名*/		
		private var packageText:String = "";
		
		/**
		 *变更包名 
		 * @param $pakage
		 */		
		public function changePackage($pakage:String):void
		{
			packageText = $pakage;
			codeChanged = true;
		}
		
		private var _fileName:String = "NewClass";

		/**文件名*/
		public function get fileName():String
		{
			return _fileName;
		}

		
		/**
		 *更改文件名 
		 * @param $name
		 */		
		public function changeName($name:String):void
		{
			this._fileName = $name;
			codeChanged = true;
		}
		
		/**修饰符*/		
		private var modifiers:String = "public";
		
		/**
		 *变更修饰符 
		 * @param $modifiers
		 */		
		public function changeModifiers($modifiers:String):void
		{
			this.modifiers = $modifiers;
			codeChanged = true;
		}
		
		/**文件类型*/
		private var type:String = "class";
		
		/**
		 *变更文件类型 
		 * @param $type
		 */		
		public function changeType($type:String):void
		{
			this.type = $type;
			codeChanged = true;
		}
		
		/**继承代码快*/
		private var extendsCB:ProfessionalCodeBlock = new ProfessionalCodeBlock(CodeTemplateID.EXTENDS_ID);
		private var extendsText:String = "";
		
		/**
		 *变更继承 
		 * @param $extends
		 */		
		public function changeExtends($extends:String):void
		{
			this.extendsText = $extends;
			codeChanged = true;
		}
		
		/**接口代码块*/
		private var implementsCB:ProfessionalCodeBlock = new ProfessionalCodeBlock(CodeTemplateID.IMPLEMENTS_ID);
		private var implementsVector:Array;
		
		/**
		 *添加的接口 
		 * @param $param
		 */		
		public function addImplements($param:String):void
		{
			if(!implementsVector)
			{
				implementsVector = [];
			}
			
			implementsVector.push($param);
			codeChanged = true;
		}
		
		/**
		 *移除接口 
		 * @param $param
		 */		
		public function removeImplements($param:String):void
		{
			if(implementsVector)
			{
				var index:int = implementsVector.indexOf($param);
				if(index != -1)
				{
					implementsVector.splice(index, 1);
					codeChanged = true;
				}
			}
		}
		
		/**导入代码块*/
		private var importCB:ProfessionalCodeBlock = new ProfessionalCodeBlock(CodeTemplateID.IMPORT_ID);
		private var importVector:Array;
		
		/**
		 *添加导入 
		 * @param $param
		 */		
		public function addImport($param:String):void
		{
			if(!importVector)
			{
				importVector = [];
			}
			
			importVector.push($param);
			codeChanged = true;
		}
		
		/**
		 *移除导入 
		 * @param $param
		 */		
		public function removeImport($param:String):void
		{
			if(importVector)
			{
				var index:int = importVector.indexOf($param);
				if(index != -1)
				{
					importVector.splice(index, 1);
					codeChanged = true;
				}
			}
		}
		
		
		override public function get codeBlock():String
		{
			if(codeChanged)
			{
				encoder(getEncodeParams());
				codeChanged = false;
			}
			return super.codeBlock;
		}
		
		/**
		 *获取编码参数列表 
		 * @return 
		 */		
		private function getEncodeParams():Array
		{
			var params:Array = [packageText];
			
			if(importVector && importVector.length > 0)
			{
				for each(var importStr:String in importVector)
				{
					importCB.encoder([importStr]);
				}
			}
			else
			{
				importCB.clear();
			}
			trace(importCB.codeBlock);
			params.push(importCB.codeBlock);
			params.push("yeah");
			params.push(modifiers);
			params.push(type);
			params.push(fileName);
			
			if(extendsText !=null && extendsText.length > 0)
			{
				extendsCB.encoder([extendsText]);
			}
			else
			{
				extendsCB.clear();
			}
			
			params.push(extendsCB.codeBlock);
			
			if(implementsVector && implementsVector.length > 0)
			{
				for each(var implementsStr:String in implementsVector)
				{
					implementsCB.encoder([implementsStr]);
				}
			}
			else
			{
				implementsCB.clear();
			}
			
			params.push(implementsCB.codeBlock);
			return params;
		}
	}
}