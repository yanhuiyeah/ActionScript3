package xlib.framework.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import xlib.framework.manager.PoolStorage;
	
	/**
	 * LazyDispatcher<br>
	 * a.构造函数没有参数：只有在LazyDispatcher的实例添加监听时才会动态创建EventDispatcher<br>
	 * b.构造函数有参数：支持多个LazyDispatcher公用一个EventDispatcher<br>
	 * @author yeah
	 */	
	public class LazyDispatcher implements IEventDispatcher
	{
		private var _dispatcher:IEventDispatcher;
		
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}

		public function set dispatcher(value:IEventDispatcher):void
		{
			_dispatcher = value;
		}
		
		private var _autoCreate:Boolean = false;

		public function get autoCreate():Boolean
		{
			return _autoCreate;
		}

		public function set autoCreate(value:Boolean):void
		{
			_autoCreate = value;
		}

		
		public function LazyDispatcher($dispatcher:IEventDispatcher = null, $autoCreate:Boolean = true)
		{
			this._dispatcher = $dispatcher;
			this._autoCreate = $autoCreate;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(!_dispatcher)
			{
				if(!autoCreate) return;
				_dispatcher = new EventDispatcher();
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(_dispatcher)
			{
				_dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			if(_dispatcher)
			{
				return _dispatcher.dispatchEvent(event);
			}
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			if(_dispatcher)
			{
				return _dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			if(_dispatcher)
			{
				return _dispatcher.willTrigger(type);
			}
			return false;
		}
		
		/**
		 *销毁（回收） 
		 */		
		public function destroy():void
		{
			reset();
			PoolStorage.instance.push(this, this["constructor"]);
		}
		
		/**
		 *重置 
		 */		
		protected function reset():void
		{
			if(dispatcher)
			{
				dispatcher = null;
			}
			autoCreate = false;
		}
	}
}