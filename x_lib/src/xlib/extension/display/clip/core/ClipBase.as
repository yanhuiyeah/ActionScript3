package xlib.extension.display.clip.core
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import xlib.extension.display.clip.insterfaces.IClip;
	import xlib.extension.display.clip.insterfaces.IClipData;
	import xlib.extension.display.clip.insterfaces.IFrameData;
	import xlib.framework.manager.TickManager;
	
	/**
	 *clip基类 
	 * @author yeah
	 */	
	public class ClipBase extends DataFrameLooper implements IClip
	{
		public function ClipBase($source:IClipData=null)
		{
			super($source);
		}
		
		public function get autoPlay():Boolean
		{
			return false;
		}
		
		public function set autoPlay($value:Boolean):void
		{
		}
		
		public function get autoRemoved():Boolean
		{
			return false;
		}
		
		public function set autoRemoved($value:Boolean):void
		{
		}
		
		public function get autoDestroy():Boolean
		{
			return false;
		}
		
		public function set autoDestroy($value:Boolean):void
		{
		}
		
		public function get pivot():Point
		{
			return null;
		}
		
		public function set pivot($value:Point):void
		{
		}
		
		public function play($frameIndex:int=-1, $frameLabel:String=null):void
		{
			if(!source)
			{
				throw new Error("还没有设置source");
			}
			execute();
		}
		
		public function stop($frameIndex:int=-1):void
		{
			halt();
		}
		
		public function pause():void
		{
		}
		
		private var bit:Bitmap;
		
		override protected function onRender($frameData:IFrameData):void
		{
			var obj:* = $frameData;
			obj = obj.data;
			if(!bit)
			{
				bit = new Bitmap();
				this.addChild(bit);
			}
			bit.bitmapData = obj;
			trace(this.frameLabel, this.frameIndex, this.repeatTimes);
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