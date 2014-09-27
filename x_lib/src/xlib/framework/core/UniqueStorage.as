package xlib.framework.core
{
	import flash.utils.Dictionary;
	
	/**
	 *唯一对象贮存器<br>
	 * 同一个对象在仓库中只能是唯一的,不会出现多个相同对象<br>
	 * 仓库中的对象是无序的<br>
	 * 禁止使用UniqueStorage[key] = value;
	 * @author yeah
	 */	
	public class UniqueStorage extends Dictionary
	{
		/**
		 * @param weekKey	是否是若引用。如果为true则flash执行垃圾回收时会回收仓库中的对象
		 */		
		public function UniqueStorage(weekKey:Boolean = false)
		{
			this.isWeek = weekKey;
			super(weekKey);
		}
		
		/**
		 *是否是若引用 
		 */		
		private var isWeek:Boolean = false;

		private var _length:int;

		/**
		 *长度<br>
		 * 如果仓库是若引用则length不可信
		 */
		public function get length():int
		{
			if(isWeek)
			{
				_length = 0;
				for each(var obj:Object in this)
				{
					_length++;
				}
			}
			return _length;
		}

		/**
		 *存入
		 * @param $objct
		 */		
		public function push($item:Object):void
		{
			if($item in this)  return;
			this[$item] = true;
			_length++;
		}
		
		/**
		 *取出<br>
		 * 取出的对象会在仓库中删除 
		 * @return 
		 */		
		public function pop():Object
		{
			var item:Object = pull();
			if(item)
			{
				delete this[item];
				_length--;
			}
			return item;
		}
		
		/**
		 *取出<br>
		 * 取出的对象不会在仓库中删除
		 * @return 
		 */		
		public function pull():Object
		{
			for(var item:Object in this)
			{
				return item;
			}
			return null;
		}
		
		/**
		 *仓库是否为空 
		 * @return 
		 */		
		public function get isEmperty():Boolean
		{
			if(isWeek)
			{
				for each(var obj:Object in this)
				{
					return false;
				}
				return true;
			}
			
			return length < 1;
		}
	}
}