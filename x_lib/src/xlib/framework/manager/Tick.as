package xlib.framework.manager
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import xlib.framework.core.LazyDispatcher;
	import xlib.framework.events.TickEvent;
	
	/**
	 *tick 代替enterframe
	 * @author yeah
	 */	
	public class Tick extends LazyDispatcher
	{
		private var _rate:Number = 1.0;
		/**
		 *帧间隔倍数（用于加速或者减速） 
		 */
		public function get rate():Number
		{
			return _rate;
		}
		
		public function set rate(value:Number):void
		{
			_rate = value;
		}
		
		private var _isPause:Boolean = false;

		/**
		 *是否处于暂停状态 
		 */		
		public function get isPause():Boolean
		{
			return _isPause;
		}
		
		/***暂停/继续*/		
		public function pause():void
		{
			_isPause = !_isPause;
		}
		
		private var _interval:int;

		/**
		 *当前tick间隔时间 
		 */
		public function get interval():int
		{
			return _interval;
		}
		
		/**
		 *销毁 
		 * @param  $clearDispatcher 是否清除disptcher
		 */		
		public function destory($clearDispatcher:Boolean = true):void
		{
			if(!_dispatcher) return;
			_dispatcher.removeEventListener(Event.ENTER_FRAME, enterFrame);
			if($clearDispatcher)
			{
				_dispatcher = null;
			}
		}
		
		public function Tick($dispatcher:EventDispatcher = null)
		{
			if(!$dispatcher || !($dispatcher is DisplayObject))
			{
				$dispatcher = new Shape();
			}
			
			_lastTime = getTimer();
			$dispatcher.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			super($dispatcher);
		}
		
		/**
		 *每帧调用 
		 * @param $e
		 */		
		private function enterFrame($e:Event):void
		{
			_times++;
			var currentTime:int = getTimer();
			if(!isPause)
			{
				_interval = (currentTime - lastTime) * rate;
				onTick(_interval);
			}
			_lastTime = currentTime;
		}
		
		/**
		 *tick 
		 * @param $interval	距离上次tick的时间间隔
		 */		
		protected function onTick($interval:int):void
		{
			if(hasEventListener(TickEvent.FRAME_TICK))
			{
				dispatchEvent(new TickEvent(TickEvent.FRAME_TICK, $interval));
			}
		}
		
		private var _lastTime:int;

		/**
		 *上一次tick时间 
		 */
		public function get lastTime():int
		{
			return _lastTime;
		}
		
		private var _times:int;

		/**
		 *执行tick的次数 
		 * @return 
		 */		
		public function get times():int
		{
			return _times;
		}


	}
}