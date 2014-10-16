package xlib.framework.core
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import xlib.framework.events.UIEvent;
	import xlib.framework.manager.PoolStorage;
	import xlib.framework.xlib_internal;
	
	use namespace xlib_internal;
	
	/**
	 *延时生效代理 <br>
	 * 请使用ValidateProxy.createSelf创建
	 * @author yeah
	 */	
	public class ValidateProxy extends LazyDispatcher implements IInvalidateElement
	{
		/**回收的key*/
		private static var RECYCLE_KEY:String;
		
		/**
		 *创建本身 
		 * @return ValidateProxy
		 */		
		public static function createSelf($target:IValidateElement):ValidateProxy
		{
			var proxy:ValidateProxy = PoolStorage.instance.pop(RECYCLE_KEY) as ValidateProxy;
			if(!proxy)
			{
				proxy = new ValidateProxy($target);
			}
			
			proxy::target = $target;
			return proxy;
		}
		
		public function ValidateProxy($target:IValidateElement)
		{
			if(!RECYCLE_KEY)
			{
				RECYCLE_KEY = getQualifiedClassName(this);
			}
			
			xlib_internal::target = $target;
			super($target);
		}
		
		private var _target:IValidateElement;
		/**
		 *延时生效 目标元素 
		 */		
		public function get target():IValidateElement
		{
			return _target;
		}

		xlib_internal function set target(value:IValidateElement):void
		{
			if(_target == value) return;
			_target = value;
			reset();
			if(!_target)
			{
				PoolStorage.instance.push(this, RECYCLE_KEY);
			}
		}

		private var _initialized:Boolean = false;
		public function set initialized($value:Boolean):void
		{
			if(this._initialized == $value) return;
			_initialized = $value;
			if(target && target.hasEventListener(UIEvent.CREATE_COMPLETE))
			{
				target.dispatchEvent(new UIEvent(UIEvent.CREATE_COMPLETE));
			}
		}
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function set nestLevel($value:int):void
		{
			if(target)
			{
				target.nestLevel = $value;
			}
		}
		
		public function get nestLevel():int
		{
			return target?target.nestLevel:0;
		}
		
		private var _updateCompletePendingFlag:Boolean = false;
		public function set updateCompletePendingFlag($value:Boolean):void
		{
			this._updateCompletePendingFlag = $value;
		}
		
		public function get updateCompletePendingFlag():Boolean
		{
			return this._updateCompletePendingFlag;
		}
		
		public function invalidateProperties():void
		{
		}
		
		public function invalidateSize():void
		{
		}
		
		public function invalidateDisplayList():void
		{
		}
		
		/**属性生效类型*/
		public static const TYPE_VALIDATEPROPERTIES:String = "validateProperties";
		/**度量生效类型*/
		public static const TYPE_VALIDATESIZE:String = "validateSize";
		/**更新显示列表生效类型*/
		public static const TYPE_VALIDATEDISPLAYLIST:String = "validateDisplayList";
		
		public function validateProperties():void
		{
			if(target)
			{
				target.validate(TYPE_VALIDATEPROPERTIES);
			}
		}
		
		public function validateSize():void
		{
			if(target)
			{
				target.validate(TYPE_VALIDATESIZE);
			}
		}
		
		public function validateDisplayList():void
		{
			if(target)
			{
				target.validate(TYPE_VALIDATEDISPLAYLIST);
			}
		}
		
		public function validateNow():void
		{
		}
		
		public function reset():void
		{
			initialized = false;
		}
	}
}