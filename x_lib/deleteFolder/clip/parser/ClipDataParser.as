package xlib.extension.display.clip.parser
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import xlib.extension.display.clip.core.interfaceClass.IClipDataParser;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameData;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.data.ClipParseredData;
	import xlib.extension.display.clip.data.DynamicClipDataList;
	import xlib.extension.display.clip.manager.ClipAssetsManager;
	import xlib.extension.display.clip.manager.ObjectPool;
	
	/**
	 *clip source 解析器
	 * @author yeah
	 */	
	public class ClipDataParser implements IClipDataParser
	{
		public function ClipDataParser()
		{
		}
		
		public function parser($source:Object, $callBack:Function, $cache:Boolean):void
		{
			if($source is IClipFrameDataList)
			{
				if($callBack != null)
				{
					$callBack.call(null, IClipFrameDataList($source));
				}
			}
			else
			{
				
				var parserData:ParserData = ObjectPool.instance.shift(getQualifiedClassName(ParserData)) as ParserData;
				if(!parserData)
				{
					parserData = new ParserData();
				}
				parserData.data = $source;
				parserData.callBack = $callBack;
				parserData.useCache = $cache;
				onParse(parserData);
			}
		}
		
		private static const BASE_PATH:String = "../";
		private function getURL($url:String):String
		{
			return BASE_PATH + $url;
		}
		
		/**
		 *开始解析 
		 * @param $value
		 * @param $callBack
		 */		
		private function onParse($parserData:ParserData):void
		{
			if($parserData.data is String)
			{
				//以下测试
				var url:String = getURL("assets/clipResource/" + $parserData.data); 
				
				var loadConfig:Function = function ():void
				{
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, 
						function loadConfigComplete($le:Event):void
						{
							$le.currentTarget.removeEventListener(Event.COMPLETE, loadConfigComplete);
							parsedComplete(XML($le.target.data), $parserData);
						});
					urlLoader.load(new URLRequest(url + ".xml"));
					
				}
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
					function loadIMGComplete($e:Event):void
					{
						$e.currentTarget.removeEventListener(Event.COMPLETE, loadIMGComplete);
						ClipAssetsManager.instance.addBitmapData($parserData.data, $e.currentTarget.content.bitmapData);
						loadConfig();
					});
				loader.load(new URLRequest(url + ".png"));
			}
		}
		
		/**
		 *解析完成 
		 * @param $data
		 * @param $callBack
		 */		
		private function parsedComplete($data:Object, $parserData:ParserData):void
		{
			if($data is XML)
			{
				var vector:Vector.<IClipFrameData> = new Vector.<IClipFrameData>();
				var config:XML = XML($data);
				
				var offsetPoint:Point = new Point(2048, 2048);
				for each(var node:XML in config.SubTexture)
				{
					vector.push(createData(node, offsetPoint));
				}
				
				for each(var fd:ClipParseredData in vector)
				{
					fd.offset = fd.offset.subtract(offsetPoint);
				}
				
				if($parserData.callBack != null)
				{
					var source:IClipFrameDataList = new DynamicClipDataList();
					source.data = vector;
					$parserData.execute(source);
					ObjectPool.instance.push($parserData);
				}
			}
		}
		
		/**
		 *创建frameData 
		 * @param $xml
		 * @return 
		 */		
		private function createData($xml:XML, $offsetPoint:Point):IClipFrameData
		{
			var xmlAttributes:XMLList = $xml.attributes();
			
			var vo:ClipParseredData = new ClipParseredData();
			var rect:Rectangle = new Rectangle();
			var offset:Point = new Point();
			for each(var xml:XML in xmlAttributes)
			{
				var key:String = xml.name();
				var value:String = xml;
				switch(key)
				{
					case "name":
						vo.frameLabel = value;
						break;
					case "frameX":
						offset.x = -int(value);
						break;
					case "frameY":
						offset.y = -int(value);
						break;
					default:
						if(key in rect)
						{
							rect[key] = value;
						}
						break;
				}
			}
			
			vo.offset = offset;
			vo.rect = rect;
			$offsetPoint.x = Math.min(offset.x, $offsetPoint.x);
			$offsetPoint.y = Math.min(offset.y, $offsetPoint.y);
			return vo;
		}
	}
}

/**
 *待解析数据 
 * @author yeah
 */
class ParserData
{
	public function ParserData()
	{
	}
	
	/**
	 *解析前的数据 
	 */	
	public var data:Object;
	
	/**
	 *回调函数 
	 */	
	public var callBack:Function;
	
	/**
	 *是否使用缓存 
	 */	
	public var useCache:Boolean = false;
	
	/**
	 *执行 
	 * @param $param
	 */	
	public function execute($param:Object):void
	{
		if(callBack != null)
		{
			callBack.call(null, $param);
		}
		this.data = null;
		this.callBack = null;
		this.useCache = false;
	}
}