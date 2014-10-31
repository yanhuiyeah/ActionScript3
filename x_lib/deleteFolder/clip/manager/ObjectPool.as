package xlib.extension.display.clip.manager
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *对象池(单例)
	 * @author yeah
	 */	
	public class ObjectPool
	{
		
		/**
		 *对象池 
		 */		
		private var pool:Dictionary = new Dictionary();
		
		/**
		 *回收对象 放入对象池
		 * @param $object		放入对象池的对象
		 * @param $key 		某类型的key  存储格式Dictionary[key] = new Dictionary(true);
		 * 								如果为null则自动设置为$object的类的完全限定名
		 */		
		public function push($object:Object, $key:String = null):void
		{
			if(!$key)
			{
				$key = getQualifiedClassName($object);
			}
			
			var dic:Dictionary;
			if($key in pool)
			{
				dic = pool[$key];
			}
			else
			{
				pool[$key] = dic = new Dictionary(true);
			}
			
			dic[$object] = true;
		}
		
		/**
		 *取出对象池中$key类型的对象
		 * @param $key		被重用对象所属类型
		 * @return 				对象池中$key所对应的对象
		 */		
		public function shift($key:String):Object
		{
			if(!($key in pool)) return null;
			
			var dic:Dictionary = pool[$key];
			var obj:Object;
			for(obj in dic)
			{
				delete dic[obj];
				break;
			}
			
			var isEmperty:Boolean = true;
			for each(var xxoo:Object in dic)
			{
				isEmperty = false;
				break;
			}
			
			if(isEmperty)
			{
				delete pool[$key];
			}
			
			return obj;
		}
		
		/**
		 *对象池中是否含有  $key 类型的对象
		 * @param $key
		 * @return 
		 */		
		public function hasOBJ($key:String):Boolean
		{
			return ($key in pool);
		}
		
		/**
		 *清除对象池中$key类型的对象
		 * @param $key某个类型  如果=null 则清除全部
		 */		
		public function clean($key:String = null):void
		{
			if($key != null && $key in pool)
			{
				delete pool[$key];
				return;
			}
			
			for($key in pool)
			{
				delete pool[$key];
			}
		}
		
		
		//===========================================
		
		private static var _instance:ObjectPool;

		/**
		 *获取 ObjectPool 实例
		 * @return ObjectPool
		 */		
		public static function get instance():ObjectPool
		{
			if(!_instance)
			{
				_instance = new ObjectPool(new objp());
			}
			return _instance;
		}
		
		public function ObjectPool($xxoo:objp)
		{
			super();
		}
	}
}

class objp
{
	public function objp(){}
}