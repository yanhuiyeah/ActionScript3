package xlib.framework.core
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import xlib.framework.core.UniqueStorage;

	/**
	 *对象池仓库 （单利）<br>
	 * 存储方式：pool[类型] = UniqueStorage;	UniqueStorage中存放具体的回收对象
	 * @author yeah
	 */	
	public class PoolStorage
	{
		
		/**
		 *对象池 
		 */		
		private var pool:Dictionary = new Dictionary();
		
		/**
		 *回收对象 放入对象池
		 * @param $item		放入对象池的对象
		 * @param $key 		某类型的key  存储格式pool[key] = new UniqueStorage(true);
		 * 								如果为null则自动设置为$object的类的完全限定名
		 */		
		public function push($item:Object, $key:String = null):void
		{
			if(!$key)
			{
				$key = getQualifiedClassName($item);
			}
			
			var storage:UniqueStorage;
			if(has($key))
			{
				storage = pool[$key];
			}
			else
			{
				storage = new UniqueStorage(true);
				pool[$key] = storage;
				_length++;
			}
			
			storage.push($item);
		}
		
		/**
		 *取出对象 <br>
		 * 调用此方法取出的对象不会在对象池中删除
		 * @param $key	池子key
		 * @return 
		 */		
		public function pull($key:String):Object
		{
			if(has($key))
			{
				var storage:UniqueStorage = pool[$key];				
				return storage.pull();
			}
			return null;
		}
		
		/**
		 * 取出对象 <br>
		 * 调用此方法取出的对象在对象池中删除
		 * @param $key
		 * @return 
		 */		
		public function pop($key:String):Object
		{
			if(has($key))
			{
				var item:Object;
				var storage:UniqueStorage = pool[$key];				
				item = storage.pop();
				if(storage.isEmperty)
				{
					delete pool[$key];
					_length--;
				}
				return item;
			}
			return null;
		}
		
		/**
		 *对象池中是否存在 $key类型的对象
		 * @param $key
		 * @return 
		 */		
		public function has($key:String):Boolean
		{
			return ($key in pool);
		}
		
		private var _length:int;

		/**
		 *获取对象池中池子的个数
		 * @return 
		 */		
		public function get length():int
		{
			return _length;
		}
		
		/**
		 *获取  $key 对应的对象池中对象的个数<br>
		 * 尽量不要调用，效率略低
		 * @param $key
		 * @return 
		 */		
		public function getLength($key:String):int
		{
			if(has($key))
			{
				var storage:UniqueStorage = pool[$key];
				return storage.length;
			}
			return 0;
		}
		
		/**
		 *清除对象池中$key类型的对象
		 * @param $key某个类型  如果=null 则清除全部
		 */		
		public function clean($key:String = null):void
		{
			if($key != null && has($key))
			{
				_length--;
				delete pool[$key];
				return;
			}
			
			for($key in pool)
			{
				delete pool[$key];
			}
			_length = 0;
		}
		
		
		//===========================================
		
		private static var _instance:PoolStorage;

		/**
		 *获取 PoolStorage 实例
		 * @return PoolStorage
		 */		
		public static function get instance():PoolStorage
		{
			if(!_instance)
			{
				_instance = new PoolStorage(new objp());
			}
			return _instance;
		}
		
		public function PoolStorage($xxoo:objp)
		{
			super();
			if($xxoo == null)
			{
				throw new Error("PoolStorage是单例类不能被实例化!");
			}
		}
	}
}

class objp
{
	public function objp(){}
}