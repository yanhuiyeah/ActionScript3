package display.moving
{
	import display.clip.core.FrameLooper;
	import display.clip.events.ClipEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class MovingProxy extends FrameLooper implements IMovingProxy
	{
		public function MovingProxy($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
			this.addEventListener(ClipEvent.FRAME, onMoving);
		}
		
		private var _hData:IMovingData;
		public function get hData():IMovingData
		{
			return _hData;
		}
		
		public function set hData($value:IMovingData):void
		{
			if(_hData == $value) return;
			_hData = $value;
		}
		
		private var _vData:IMovingData;
		public function get vData():IMovingData
		{
			return _vData;
		}
		
		public function set vData($value:IMovingData):void
		{
			if(_vData == $value) return;
			_vData = $value;
		}
		
		private var _target:DisplayObject;
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set target($value:DisplayObject):void
		{
			_target = $value;
			
			if(!_target)
			{
				gotoAndStop();
			}
		}
		
		/**
		 *移动 
		 * @param event
		 */		
		private function onMoving(event:Event):void
		{
			if(!target)
			{
				throw new Error("target == null");
			}
			
			if(hData)
			{
				target.x += hData.calculateSpeed();
			}
			
			if(vData)
			{
				target.y += vData.calculateSpeed();
			}
		}
		
	}
}