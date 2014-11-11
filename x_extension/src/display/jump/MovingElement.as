package display.jump
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
		
		private var _rate:int = 1;
		public function get rate():int
		{
			return _rate;
		}
		
		public function set rate($value:int):void
		{
			if($value == _rate) return;
			_rate = $value;
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
		
		public function calculateSpeed():int
		{
			speed += rate * accelerate;
			var newRate:int = rate;
			if(maxSpeed != -1 && speed >= maxSpeed)
			{
				newRate = -rate;
				speed = maxSpeed;
			}
			
			if(miniSpeed != -1 && speed <= miniSpeed)
			{
				newRate = -rate;
				speed = miniSpeed;
			}
			
			var s:int = rate * speed;
			rate = newRate;
			return s;
		}
		
		private var _maxSpeed:int = -1;

		public function get maxSpeed():int
		{
			return _maxSpeed;
		}

		public function set maxSpeed(value:int):void
		{
			_maxSpeed = value;
		}
		
		private var _miniSpeed:int = -1;

		public function get miniSpeed():int
		{
			return _miniSpeed;
		}

		public function set miniSpeed(value:int):void
		{
			_miniSpeed = value;
		}


	}
}