package display.moving
{
	import flash.display.DisplayObject;
	
	import display.clip.Clip;
	import display.clip.insterfaces.IClipData;
	import xlib.framework.manager.TickManager;
	
	public class MovingElement extends Clip implements IMovingElement
	{
		public function MovingElement($source:IClipData=null)
		{
			super($source);
		}
		
		
		private var _horizontal:IMovingData;
		public function get horizontal():IMovingData
		{
			return _horizontal;
		}
		
		public function set horizontal($value:IMovingData):void
		{
			if(_horizontal == $value) return;
			_horizontal = $value;
		}
		
		private var _vertical:IMovingData;
		public function get vertical():IMovingData
		{
			return _vertical;
		}
		
		public function set vertical($value:IMovingData):void
		{
			if(_vertical == $value) return;
			_vertical = $value;
		}
		
		public function get self():DisplayObject
		{
			return this;
		}
		
		public function go():void
		{
			vertical = new MovingData();
			vertical.accelerate = 2;
			vertical.speed = 0;
			vertical.miniSpeed = 0;
			
			horizontal = new MovingData();
			horizontal.speed = 3;
			horizontal.accelerate = 1;
			horizontal.maxSpeed = 10;
			horizontal.miniSpeed = 0;
			TickManager.instance.doFrame(run, 1);
		}
		
		public function kill():void
		{
		}
		
		private function run():void
		{
			if(!horizontal || !vertical)
			{
				throw new Error("呵呵!");
			}
//			this.y += vertical.calculateSpeed();
			this.x += horizontal.calculateSpeed();
		}
	}
}