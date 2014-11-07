package display.clip
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import display.clip.core.ClipBase;
	import display.clip.data.FrameData;
	import display.clip.events.ClipEvent;
	import display.clip.insterfaces.IClipData;
	import display.clip.insterfaces.IFrameData;
	import xlib.framework.manager.TickManager;
	
	/**播放结束*/
	[Event(name="complete", type="display.clip.events.ClipEvent")]
	/**一个循环*/
	[Event(name="repeat", type="display.clip.events.ClipEvent")]
	/**每帧*/
	[Event(name="frame", type="display.clip.events.ClipEvent")]
	
	/**
	 *clip 序列帧播放器
	 * @author yeah
	 */	
	public class Clip extends ClipBase
	{
		public function Clip($source:IClipData=null)
		{
			super($source);
		}
		
		override protected function onRender($frameData:IFrameData):void
		{
			var fd:FrameData = $frameData as FrameData;
			if(!fd) return;
			
			var p:Point = fd.offset;
			var posx:int;
			var posy:int;
			if(p)
			{
				posx = p.x;
				posy = p.y;
			}
			this.graphics.clear();
			this.graphics.beginBitmapFill(fd.data as BitmapData, getMatrix(p));
			this.graphics.drawRect(posx, posy, fd.data.width, fd.data.height);
			this.graphics.endFill();
		}
		
		private var matrix:Matrix;
		/**
		 *获取渲染matrix
		 * @param $offset
		 * @return 
		 */		
		private function getMatrix($offset:Point):Matrix
		{
			if($offset)
			{
				if(!matrix)
				{
					matrix = new Matrix();
				}
				matrix.identity();
				matrix.translate($offset.x, $offset.y);
				return matrix;
			}
			return null;
		}
		
		override protected function onEnd():void
		{
			super.onEnd();
			stop();
			this.dispatchEvent(new ClipEvent(ClipEvent.COMPLETE));
		}
		
		override protected function onRepeat():void
		{
			super.onRepeat();
			this.dispatchEvent(new ClipEvent(ClipEvent.REPEAT));
		}
		
		override protected function onFrame():void
		{
			super.onFrame();
			this.dispatchEvent(new ClipEvent(ClipEvent.FRAME));
		}
		
		override protected function registerTimer($enterFrame:Function):void
		{
			TickManager.instance.doDuration($enterFrame, this.frameDuration);	
		}
		
		override protected function unRegisterTimer($enterFrame:Function):void
		{
			TickManager.instance.clean($enterFrame);
		}
	}
}