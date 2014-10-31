package xlib.extension.display.clip
{
	import flash.utils.getQualifiedClassName;
	
	import xlib.extension.display.clip.manager.ClipManager;
	import xlib.extension.display.clip.core.interfaceClass.IClipDataParser;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.core.interfaceClass.IClipRenderer;
	import xlib.extension.display.clip.core.interfaceClass.IParserClip;
	import xlib.extension.display.clip.render.ClipRenderer;
	
	/**
	 *普通clip 
	 * 如果数据源不是IClipFrameDataList 请使用Clip 并且 设置 clip.sourceData = 数据源, 以便dataParser可以解析
	 * 如果source已经准备好 不需要等待处理 请优先使用BaseClip
	 * @author yeah
	 */	
	public class Clip extends BaseClip implements IParserClip
	{
		public function Clip($source:IClipFrameDataList=null)
		{
			super($source);
		}
		
		private var _cacheBitmapData:Boolean = true;
		public function get cacheBitmapData():Boolean
		{
			return _cacheBitmapData;
		}

		public function set cacheBitmapData(value:Boolean):void
		{
			if(this._cacheBitmapData == value) return;
			_cacheBitmapData = value;
			invalidateParser();
		}
		
		
		private var _sourceData:Object;
		public function get sourceData():Object
		{
			return _sourceData;
		}
		
		public function set sourceData($value:Object):void
		{
			if(this._sourceData == $value) return;
			_sourceData = $value;
			invalidateParser();
		}
		
		private var _dataParser:IClipDataParser;
		public function get dataParser():IClipDataParser
		{
			return _dataParser;
		}
		
		public function set dataParser($value:IClipDataParser):void
		{
			if(this._dataParser == $value) return;
			this._dataParser = $value;
			invalidateParser();
		}
		
		/**
		 *数据待解析标志 
		 */		
		private var parserDirty:Boolean = false;
		
		/**
		 *解析行为生效 , 下一个Event.Render后解析数据
		 */		
		private function invalidateParser():void
		{
			parserDirty = true;
			invalidateProperties();
		}
		
		override public function set clipRenderer($value:IClipRenderer):void
		{
			if($value is ClipRenderer)
			{
				ClipRenderer($value).parsedKey = this.sourceData;
			}
			
			super.clipRenderer = $value;
		}
		
		/**
		 *提交解析数据行为
		 */		
		protected function commitParserData():void
		{
			if(sourceData == null)
			{
				source = null;
				return;
			}
			
			if(!dataParser)
			{
				dataParser = createDefaultDataParser();
			}
			
			if(clipRenderer is ClipRenderer)
			{
				ClipRenderer(clipRenderer).parsedKey = this.sourceData;
			}
			
			dataParser.parser(this.sourceData, parsedComplete, this.cacheBitmapData);
		}
		
		/**
		 *解析完成 
		 * @param $data
		 */		
		private function parsedComplete($data:IClipFrameDataList):void
		{
			source = $data;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(parserDirty)
			{
				commitParserData();
				parserDirty = false;
			}
		}
		
		/**
		 *创建默认解析器 
		 * @return 
		 */		
		protected function createDefaultDataParser():IClipDataParser
		{
			return ClipManager.instance.getClipDataParser(getDataParserKey());
		}
		
		/**
		 * 返回ClipManager注册IClipDataParser的键 
		 * 子类可覆盖此方法 以便创建不同的IClipDataParser
		 */		
		protected function getDataParserKey():Object
		{
			return getQualifiedClassName(IClipDataParser);
		}
		
		override protected function getClipRenderKey():Object
		{
			return getQualifiedClassName(IParserClip);
		}
	}
}