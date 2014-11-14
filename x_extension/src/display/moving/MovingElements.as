package display.moving
{
	import display.clip.core.FrameLooper;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	public class MovingElements extends FrameLooper implements IMovingElement
	{
		public function MovingElements($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
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
		}
	}
}