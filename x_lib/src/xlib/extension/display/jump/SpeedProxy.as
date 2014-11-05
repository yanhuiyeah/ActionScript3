package xlib.extension.display.jump
{
	import flash.events.IEventDispatcher;
	
	import xlib.framework.core.LazyDispatcher;
	
	public class SpeedProxy extends LazyDispatcher
	{
		public function SpeedProxy($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		private var _target:ISpeed;

		public function get target():ISpeed
		{
			return _target;
		}

		public function set target(value:ISpeed):void
		{
			_target = value;
		}
		
		
		public function play():void
		{
			
		}
	}
}