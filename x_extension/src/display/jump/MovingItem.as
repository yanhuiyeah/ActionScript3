package display.jump
{
	import flash.display.DisplayObject;
	
	import display.clip.Clip;
	import display.clip.insterfaces.IClipData;
	import xlib.framework.manager.TickManager;
	
	public class MovingItem extends Clip implements IMoving
	{
		public function MovingItem($source:IClipData=null)
		{
			super($source);
		}
		
		
		private var _horizontal:IMovingElement;
		public function get horizontal():IMovingElement
		{
			return _horizontal;
		}
		
		public function set horizontal($value:IMovingElement):void
		{
			if(_horizontal == $value) return;
			_horizontal = $value;
		}
		
		private var _vertical:IMovingElement;
		public function get vertical():IMovingElement
		{
			return _vertical;
		}
		
		public function set vertical($value:IMovingElement):void
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
			vertical = new MovingElement();
			vertical.accelerate = 2;
			vertical.speed = 0;
			vertical.miniSpeed = 0;
			
			horizontal = new MovingElement();
			horizontal.rate = 1;
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