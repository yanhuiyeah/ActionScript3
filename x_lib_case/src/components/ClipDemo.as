package components
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import xlib.extension.display.clip.Clip;
	import xlib.extension.display.clip.core.ClipBase;
	import xlib.extension.display.clip.events.ClipEvent;
	import xlib.extension.display.clip.insterfaces.IClip;
	import xlib.framework.Application;
	
	public class ClipDemo extends Application
	{
		
		
		
		private var clip:IClip;
		
		public function ClipDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			clip = new Clip();
			clip.addEventListener(ClipEvent.COMPLETE, onClipEvent);
			clip.addEventListener(ClipEvent.FRAME, onClipEvent);
			clip.addEventListener(ClipEvent.REPEAT, onClipEvent);
//			clip.pivot = new Point(424, 342);
			clip.frameDuration = 200;
//			clip.repeat = 30;
			clip.autoPlay = true;
//			clip.autoRemoved = true;
			clip.source = new cd();
			this.addChild(clip as DisplayObject);
//			clip.play("3000");
			stage.addEventListener(MouseEvent.CLICK, onClik);
		}
		
		protected function onClipEvent(event:ClipEvent):void
		{
			trace(event.type, clip.frameIndex,  clip.frameLabel,  clip.repeatTimes,  clip.repeat);
		}
		
		private var flag:Boolean = false;
		protected function onClik(event:MouseEvent):void
		{
			if(!(clip as DisplayObject).parent)
			{
				this.addChild(clip as DisplayObject);
			}
			else
			{
				this.removeChild(clip as DisplayObject);
			}return;
			
//			this.addChild(clip as DisplayObject);return;
//			clip.frameLabel = clip.frameLabel == "3000" ? "6000":"3000";	
//			this.removeChild(clip);
//			clip = null;
			flag = !flag;
			flag ?clip.pause():clip.resume();
		}		
		
		
		
		
	}
}

















import flash.display.BitmapData;

import xlib.extension.display.clip.data.ClipData;
import xlib.extension.display.clip.data.FrameData;
import xlib.extension.display.clip.insterfaces.IFrameData;

class cd extends ClipData
{
	public function cd()
	{
		super();
		
		for (var j:int = 3; j < 7; j+=3) 
		{
			var vect:Vector.<IFrameData> = new Vector.<IFrameData>();
			for (var i:int = 0; i < 6; i++) 
			{
				var d:FrameData = new FrameData();
				d.data = (new (this["img" +j+"000" + i] as Class)()).bitmapData;
				vect.push(d);
			}
			addFrames(vect, j + "000");
		}
		
	}
	
	
	[Embed(source="../assets/clip/30000.png")]
	private var img30000:Class;
	[Embed(source="../assets/clip/30001.png")]
	private var img30001:Class;
	[Embed(source="../assets/clip/30002.png")]
	private var img30002:Class;
	[Embed(source="../assets/clip/30003.png")]
	private var img30003:Class;
	[Embed(source="../assets/clip/30004.png")]
	private var img30004:Class;
	[Embed(source="../assets/clip/30005.png")]
	private var img30005:Class;
	
	[Embed(source="../assets/clip/60000.png")]
	private var img60000:Class;
	[Embed(source="../assets/clip/60001.png")]
	private var img60001:Class;
	[Embed(source="../assets/clip/60002.png")]
	private var img60002:Class;
	[Embed(source="../assets/clip/60003.png")]
	private var img60003:Class;
	[Embed(source="../assets/clip/60004.png")]
	private var img60004:Class;
	[Embed(source="../assets/clip/60005.png")]
	private var img60005:Class;
}
