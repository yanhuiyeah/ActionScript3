package xlib.framework.manager
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *注入 管理器
	 * @author yeah
	 */	
	public class Injector
	{
		public function Injector()
		{
		}
	
		/**
		 *字典 
		 */		
		private var dic:Dictionary = new Dictionary();
		
		/**
		 *key字典 
		 */		
		private var keyDic:Dictionary = new Dictionary();
		
		private static const DEFAULT_OFFSET:String = "#";
		
		
		/**
		 *注入 
		 * @param $key			key
		 * @param $value			将要注入的对象
		 * @param $offset		区分符号(有的一个key可能会对应多个$value)
		 */		
		public function inject($key:Object, $value:*, $offset:String = DEFAULT_OFFSET):void
		{
			var key:String = getKey($key);
			keyDic[$key] = key;
			key += $offset;
			dic[key] = $value;
		}
		
		/**
		 *取出已经注入的对象
		 * @param $key
		 * @param $offset
		 */		
		public function pull($key:Object, $offset:String = DEFAULT_OFFSET):*
		{
			var key:String = getKey($key) + $offset;
			if(key in dic)
			{
				return dic[key];
			}
			return null;
		}
		
		/**
		 *移除已经注入的对象 
		 * @param $key
		 * @return
		 */		
		public function remove($key:Object, $offset:String = DEFAULT_OFFSET):Object
		{
			var o:Object;
			var key:String = getKey($key) + $offset;
			if(key in dic)
			{
				o = dic[key];
				delete dic[key];
			}
			
			if($key in keyDic)
			{
				delete keyDic[$key];
			}
			return o;
		}
		
		/**
		 *获取key字符串 
		 * @param $obj
		 * @return 
		 */		
		private function getKey($key:Object):String
		{
			if($key in keyDic)
			{
				return keyDic[$key];
			}
			return getQualifiedClassName($key);
		}
		
		
		private static var _instance:Injector;
		/**
		 *单例 
		 * @return 
		 */		
		public static function get instance():Injector
		{
			if(!_instance)
			{
				_instance = new Injector();
			}
			return _instance;
		}

	}
}