package display.moving
{
	
	/**
	 *移动元素 
	 * @author yeah
	 */	
	public class MovingData implements IMovingData
	{
		public function MovingData()
		{
		}
		
		private var _quicken:Boolean = true;
		public function get quicken():Boolean
		{
			return _quicken;
		}

		public function set quicken(value:Boolean):void
		{
			if(_quicken == value) return;
			_quicken = value;
		}

		
		private var _speed:Number = 0;
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed($value:Number):void
		{
			if(_speed == $value) return;
			_speed = $value;
		}
		
		private var _accelerate:Number = 0;
		public function get accelerate():Number
		{
			return _accelerate;
		}
		
		public function set accelerate($value:Number):void
		{
			if(_accelerate == $value) return;
			_accelerate = $value;
		}
		
		private var _maxSpeed:Number = -1;
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}

		public function set maxSpeed(value:Number):void
		{
			_maxSpeed = value;
		}
		
		private var _miniSpeed:Number = -1;
		public function get miniSpeed():Number
		{
			return _miniSpeed;
		}

		public function set miniSpeed(value:Number):void
		{
			_miniSpeed = value;
		}
		
		public function calculateSpeed():Number
		{
			var flag:int = quicken ? 1 : -1;
			speed += accelerate * flag;
			
			if(maxSpeed != -1 && speed >= maxSpeed)
			{
				quicken = !quicken;
				speed = maxSpeed;
			}
			
			if(miniSpeed != -1 && speed <= miniSpeed)
			{
				quicken = !quicken;
				speed = miniSpeed;
			}
			
			return speed;
		}


	}
}