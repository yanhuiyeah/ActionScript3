package xlib.extension.display.jump
{
	import flash.display.DisplayObject;
	
	import xlib.extension.display.clip.Clip;
	
	public class Speed extends Clip implements ISpeed
	{
		public function Speed()
		{
			super();
		}
		
		private var _accelerate:int = 5;
		public function get accelerate():int
		{
			return _accelerate;
		}
		
		public function set accelerate($value:int):void
		{
			_accelerate = $value;
		}
		
		private var _speed:int = 10;
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed($value:int):void
		{
			_speed = $value;
		}
		
		private var _horizontalDirection:int = 1;
		public function get horizontalDirection():int
		{
			return _horizontalDirection;
		}
		
		public function set horizontalDirection($value:int):void
		{
			this._horizontalDirection = $value;
		}
		
		private var _verticalDirection:int = 1;
		public function get verticalDirection():int
		{
			return _verticalDirection;
		}
		
		public function set verticalDirection($value:int):void
		{
			_verticalDirection = $value;
		}
		
		public function get self():DisplayObject
		{
			return this;
		}
	}
}