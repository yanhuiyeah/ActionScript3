package xlib.extension.display.jump
{
	
	/**
	 *移动元素 
	 * @author yeah
	 */	
	public class MovingElement implements IMovingElement
	{
		public function MovingElement()
		{
		}
		
		private var _forward:Boolean = true;
		public function get forward():Boolean
		{
			return _forward;
		}
		
		public function set forward($value:Boolean):void
		{
			if($value == _forward) return;
			_forward = $value;
		}
		
		private var _speed:int;
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed($value:int):void
		{
			if(_speed == $value) return;
			_speed = $value;
		}
		
		private var _accelerate:int;
		public function get accelerate():int
		{
			return _accelerate;
		}
		
		public function set accelerate($value:int):void
		{
			if(_accelerate == $value) return;
			_accelerate = $value;
		}
	}
}