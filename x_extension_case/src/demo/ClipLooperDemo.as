package demo
{
	import display.clip.core.ClipLooper;
	import display.clip.core.FrameLooper;
	import display.clip.events.ClipEvent;
	import display.clip.insterfaces.IFrameLooper;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import xlib.framework.Application;
	
	public class ClipLooperDemo extends Application
	{
		
		private var loopers:IFrameLooper;
		
		public function ClipLooperDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.graphics.beginFill(0x0000ff, .5);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
			
			loopers = new ClipLooper();
			loopOBJ = loopers as DisplayObject;
			loopers.addEventListener(ClipEvent.FRAME, onEvent);
			loopers.addEventListener(ClipEvent.REPEAT, onEvent);
			loopers.addEventListener(ClipEvent.COMPLETE, onEvent);
			loopers.loopFrames = 6;
			loopers.repeat = 10;
			loopers.frameDuration = 100;
			loopers.gotoAndPlay();
			this.addChild(loopOBJ);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private var loopOBJ:DisplayObject;
		
		private function onEvent($e:ClipEvent):void
		{
			trace($e.type, loopers.frameIndex, loopers.repeatTimes, loopers.repeat);
		}
		
		protected function onClick(event:Event):void
		{
			if(loopOBJ.parent)
			{
				loopOBJ.parent.removeChild(loopOBJ);
			}
			else
			{
				this.addChild(loopOBJ);
			}
//			loopers.frameDuration = 200;
//			loopers.isPlaying ? loopers.pause():loopers.resume();
		}
	}
}
