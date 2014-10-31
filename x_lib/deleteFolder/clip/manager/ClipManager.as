package xlib.extension.display.clip.manager
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import xlib.extension.display.clip.core.interfaceClass.IClip;
	import xlib.extension.display.clip.core.interfaceClass.IClipDataParser;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.core.interfaceClass.IClipRenderer;
	import xlib.extension.display.clip.core.interfaceClass.IParserClip;
	import xlib.extension.display.clip.parser.ClipDataParser;
	import xlib.extension.display.clip.render.BaseClipRenderer;
	import xlib.extension.display.clip.render.ClipRenderer;

	public class ClipManager
	{
		/**
		 * 已经注册的class字典
		 */		
		private var dic:Dictionary;
		
		/**
		 *注册
		 * @param $key					注册的key
		 * @param $value					对象
		 */		
		public function register($key:Object, $value:Object):void
		{
			if(!dic)
			{
				dic = new Dictionary();
			}
			
			var key:String = keyToString($key);
			dic[key] = $value;
		}
		
		/**
		 *解除注册 
		 * @param $key
		 * @return true:解除成功 false:$key不存在注册字典
		 */		
		public function unRegister($key:Object):Boolean
		{
			if(dic)
			{
				var key:String = keyToString($key);
				if(key in dic)
				{
					delete dic[$key];
					return true;
				}
			}
			return false;
		}
		
		/**
		 * $key is String return $key
		 * else return getQualifiedClassName($key)
		 * @param $key
		 */		
		private function keyToString($key:Object):String
		{
			if($key is String) return String($key);
			return getQualifiedClassName($key);
		}
		
		/**
		 *返回一个已经注册过的实例（如果注册的是Class 则创建class，否则直接返回注册的对象）
		 * @param $key							key
		 * @param $constructedParam		构造函数参数（预留）
		 * @param $constructedParam		构造函数参数（预留）
		 * @return 
		 */		
		public function getInstance($key:Object, $constructedParam:Array = null):Object
		{
			var key:String = keyToString($key);
			
			/**先从对象池中取**/
			var instanceOBJ:* = ObjectPool.instance.shift(key);
			
			if(instanceOBJ) return instanceOBJ;
			
			/**创建一个新的实例*/
			if(dic && key in dic)
			{
				instanceOBJ = dic[key];
				if(instanceOBJ is Class)
				{
					instanceOBJ = new instanceOBJ();
				}
				return instanceOBJ;
			}
			
			return null;
		}
		
		/**
		 *获取Clip中cliprender的实例 
		 * @param $clipRenderKey	Clilp对象中的clipRenderKey  
		 * @return IClipRenderer
		 */		
		public function getClipRenderer($clipRenderKey:Object):IClipRenderer
		{
			return (getInstance($clipRenderKey) as IClipRenderer);
		}
		
		/**
		 *获取Clip中dataParser的实例 
		 * @param $dataParserKey	Clip对象中的getDataParserKey  
		 * @return IClipDataParser
		 */		
		public function getClipDataParser($dataParserKey :Object):IClipDataParser
		{
			return (getInstance($dataParserKey) as IClipDataParser);
		}
		
		/**
		 *初始化
		 */		
		private function initClipManager():void
		{
			/**clipRender*/
			register(IClip, BaseClipRenderer);
			register(IParserClip, ClipRenderer);
			
			/**dataParser*/			
			register(IClipDataParser, new ClipDataParser());
		}
		
		//===================================
		
		/**
		 *创建Clip
		 * @param $class
		 * @param $data
		 * @return 
		 */		
		public function create($class:Class, $data:Object = null):IClip
		{
			var key:String = getQualifiedClassName($class);
			var clip:IClip = ObjectPool.instance.shift(key) as IClip;
			
			if(!clip)
			{
				clip = new $class() as IClip;
			}
			
			if(clip)
			{
				setClip(clip, $data);
				clip.addEventListener(Event.REMOVED_FROM_STAGE, function recycleClip($e:Event):void
				{
					if(clip.isPlaying)
					{
						clip.stop();
					}
					clip.removeEventListener(Event.REMOVED_FROM_STAGE, recycleClip);
				});
			}
			
			return clip;
		}
		
		/**
		 *设置clip 
		 * @param $clip
		 * @param $data
		 */		
		private function setClip($clip:IClip, $data:Object):void
		{
			if(!$data) return;
			
			if($data is IClipFrameDataList)
			{
				$clip.source = IClipFrameDataList($data);
			}
			else if($clip is IParserClip)
			{
				IParserClip($clip).sourceData = $data;
			}
		}	
		
		//==================================
		
		public function ClipManager()
		{
			if(_instance)
			{
				throw new Error("单利类不能被重复初始化");
			}
			initClipManager();//待定
		}
		
		
		private static var _instance:ClipManager;

		public static function get instance():ClipManager
		{
			if(!_instance)
			{
				_instance = new ClipManager();
			}
			return _instance;
		}
	}
}