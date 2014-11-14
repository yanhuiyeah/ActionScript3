package demo
{
	import display.clip.core.ClipLooper;
	import display.clip.core.FrameLooper;
	import display.clip.events.ClipEvent;
	import display.clip.insterfaces.IFrameLooper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import xlib.framework.Application;
	
	public class FrameLooperDemo extends Application
	{
		
		private var loopers:IFrameLooper;
		
		public function FrameLooperDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.graphics.beginFill(0x0000ff, .5);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
			
			loopers = new FrameLooper();
			loopers.addEventListener(ClipEvent.FRAME, onEvent);
			loopers.addEventListener(ClipEvent.REPEAT, onEvent);
			loopers.addEventListener(ClipEvent.COMPLETE, onEvent);
			loopers.loopFrames = 6;
			loopers.repeat = 10;
			loopers.frameDuration = 100;
			loopers.gotoAndPlay();
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onEvent($e:ClipEvent):void
		{
			trace($e.type, loopers.frameIndex, loopers.repeatTimes, loopers.repeat);
		}
		
		protected function onClick(event:Event):void
		{
//			loopers.frameDuration = 200;
			loopers.isPlaying ? loopers.pause():loopers.resume();
		}
	}
}
