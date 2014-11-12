package demo
{
	import display.clip.core.FrameLoopers;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import xlib.framework.Application;
	
	public class FrameLoopersDemo extends Application
	{
		
		private var loopers:fl;
		
		public function FrameLoopersDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.graphics.beginFill(0x0000ff, .5);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
			
			loopers = new fl();
			loopers.loopFrames = 5;
			loopers.frameDuration = 200;
			loopers.repeat = 2;
//			this.addChild(loopers);
			loopers.gotoAndPlay();
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:Event):void
		{
			this.addChild(loopers);
		}
	}
}


import display.clip.core.FrameLoopers;

import xlib.framework.manager.TickManager;


class fl extends FrameLoopers
{
	public function fl()
	{
		super();
	}
	
	override protected function registerTimer($frameHandler:Function):void
	{
		TickManager.instance.doDuration($frameHandler, this.frameDuration);
	}
	
	override protected function unRegisterTimer($frameHandler:Function):void
	{
		TickManager.instance.clean($frameHandler);
	}
}