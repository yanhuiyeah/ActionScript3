package xlib.framework.manager
{
	import flash.utils.Dictionary;

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
		 *注入 
		 * @param $key			key
		 * @param $instance	实例
		 * @param $offset		区分符号(有的一个key可能会对应多个$instance)
		 */		
		public function inject($key:Object, $instance:Object, $offset:String = "@"):void
		{
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