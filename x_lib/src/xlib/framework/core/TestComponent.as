package xlib.framework.core
{
	import flash.display.Sprite;
	
	import xlib.framework.xlib_internal;
	
	use namespace xlib_internal;
	
	public class TestComponent extends Sprite implements IValidateElement
	{
		public function TestComponent()
		{
			super();
			this._validateProxy = ValidateProxy.createSelf(this);
		}
		
		public function validate($type:String):void
		{
		}
		
		private var _validateProxy:ValidateProxy;
		
		public function get validateProxy():ValidateProxy
		{
			return _validateProxy;
		}
		
		public function destroy():void
		{
			if(validateProxy)
			{
				validateProxy::target = null;
			}
		}
		
		public function set nestLevel($value:int):void
		{
		}
		
		public function get nestLevel():int
		{
			return 0;
		}
	}
}