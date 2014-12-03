package xlib.framework.manager.supportClasses
{
	import flash.utils.Dictionary;
	
	import xlib.framework.core.interfaces.IInvalidateElement;

	/**
	 *渲染队列 （参与布局三阶段的IInvalidateElement队列）
	 * @author yeah
	 */	
	public class RenderQueue
	{
		
		/**
		 *队列 
		 */		
		private var queue:Dictionary;
		
		/**
		 * 队列中最小的nestLevel
		 */		
		private var min:int = 0;
		
		/**
		 *队列中最大的 nestLevel
		 */		
		private var max:int = -1;
		
		/**
		 *放入队列 
		 * @param $element
		 */		
		public function push($element:IInvalidateElement):void
		{
			var nestLevel:int = $element.nestLevel;
			if(min > max)
			{
				min = max = nestLevel;
			}
			else if(min > nestLevel)
			{
				min = nestLevel;
			}
			else if(nestLevel > max)
			{
				max = nestLevel;
			}
			var storage:UniqueStorage = getStorage(nestLevel);
			if(!storage)
			{
				storage = new UniqueStorage();
				queue[nestLevel] = storage;
			}
			storage.push($element);
		}
		
		/**
		 *按照 IInvalidateElement.nestLevel 升序取出IInvalidateElement<br>
		 * @return	IInvalidateElement
		 */		
		public function shift():IInvalidateElement
		{
			var element:IInvalidateElement;
			var storage:UniqueStorage = getStorage(min);
			if(storage)
			{
				element = storage.pop() as IInvalidateElement;
				if(storage.length < 1)
				{
					deleteStore(min);
					storage = null;
				}
			}
			
			while(!storage)
			{
				min++;
				if(min > max)
				{
					break;
				}
				storage = getStorage(min);
			}
			
			return element;
		}
		
		/**
		 *按照 IInvalidateElement.nestLevel 降序取出IInvalidateElement<br>
		 * @return IInvalidateElement
		 */			
		public function pop():IInvalidateElement
		{
			var element:IInvalidateElement;
			var storage:UniqueStorage = getStorage(max);
			if(storage)
			{
				element = storage.pop() as IInvalidateElement;
				if(storage.isEmperty)
				{
					deleteStore(max);
					storage = null;
				}
			}
			
			while(!storage)
			{
				max--;
				if(min > max)
				{
					break;
				}
				storage = getStorage(max);
			}
			
			return element;
		}
		
		/**
		 *按照 IInvalidateElement.nestLevel 升序取出nestLevel>=$origin的IInvalidateElement<br>
		 * @param	 $origin某个IInvalidateElement.nestLevel的值
		 * @return	IInvalidateElement
		 */		
		public function shiftBehind($origin:int = 0):IInvalidateElement
		{
			if($origin > max) return null;
			
			if($origin <= min) 
			{
				return shift();
			}
			
			var element:IInvalidateElement;
			var storage:UniqueStorage = getStorage($origin);
			while(!storage)
			{
				$origin++;
				storage = getStorage($origin);
				if($origin > max)
				{
					return null;
				}
			}
			
			if(storage)
			{
				element = storage.pop() as IInvalidateElement;
				if(storage.length < 1)
				{
					deleteStore($origin);
					storage = null;
				}
			}
			return element;
		}
		
		/**
		 *按照 IInvalidateElement.nestLevel 降序取出nestLevel>=$origin的IInvalidateElement<br>
		 * @param	 $origin某个IInvalidateElement.nestLevel的值
		 * @return IInvalidateElement
		 */			
		public function popBehind($origin:int = 0):IInvalidateElement
		{
			if($origin > max) return null;
			var element:IInvalidateElement = pop();
			if(element.nestLevel < $origin)
			{
				push(element);
				return null;
			}
			return element;
		}
		
		/**
		 *获取 $nestLevel对应的仓库
		 * @param $nestLevel
		 * @return 
		 */		
		private function getStorage($nestLevel:int):UniqueStorage
		{
			if($nestLevel in queue)
			{
				return queue[$nestLevel];
			}
			return null;
		}
		
		/**
		 *删除 $nestLevel对应的仓库
		 * @param $nestLevel
		 */		
		private function deleteStore($nestLevel:int):void
		{
			delete queue[$nestLevel];
		}
		
		/**
		 *队列是否为空 
		 * @return 
		 */		
		public function isEmperty():Boolean
		{
			return min > max;
		}
		
		public function RenderQueue()
		{
			queue = new Dictionary();
		}
		
	}
}