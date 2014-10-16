package xlib.framework.core
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import xlib.framework.events.UIEvent;
	import xlib.framework.manager.PoolStorage;
	
	/**
	 *布局代理 <br>
	 * 请使用LayoutProxy.createSelf创建
	 * @author yeah
	 */	
	public class LayoutProxy extends LazyDispatcher
	{
		/**回收的key*/
		private static var RECYCLE_KEY:String;
		
		/**
		 *创建本身 
		 * @return ValidateProxy
		 */		
		public static function createSelf($target:ILayoutElement):LayoutProxy
		{
			var proxy:LayoutProxy = PoolStorage.instance.pop(RECYCLE_KEY) as LayoutProxy;
			if(!proxy)
			{
				proxy = new LayoutProxy($target);
			}
			
			proxy.target = $target;
			return proxy;
		}
		
		public function LayoutProxy($target:ILayoutElement)
		{
			if(!RECYCLE_KEY)
			{
				RECYCLE_KEY = getQualifiedClassName(this);
			}
			
			target = $target;
			super($target);
		}
		
		private var _target:ILayoutElement;
		/**
		 *延时生效 目标元素 
		 */		
		public function get target():ILayoutElement
		{
			return _target;
		}

		public function set target(value:ILayoutElement):void
		{
			if(_target == value) return;
			_target = value;
			reset();
			if(!_target)
			{
				PoolStorage.instance.push(this, RECYCLE_KEY);
			}
		}

		
		public function reset():void
		{
			target = null;
		}
	}
}