package components
{
	import flash.events.MouseEvent;
	
	import xlib.extension.display.clip.core.ClipBase;
	import xlib.framework.Application;
	
	public class ClipDemo extends Application
	{
		
		
		
		private var clip:ClipBase;
		
		public function ClipDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			clip = new ClipBase();
			clip.frameDuration = 200;
			clip.source = new cd();
			clip.frameLabel = "3000";
			this.addChild(clip);
			clip.play();
			stage.addEventListener(MouseEvent.CLICK, onClik);
		}
		
		protected function onClik(event:MouseEvent):void
		{
			clip.frameLabel = clip.frameLabel == "3000" ? "6000":"3000";	
//			this.removeChild(clip);
//			clip = null;
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
				var d:fd = new fd();
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

class fd extends FrameData
{
	public function fd()
	{
		super();
	}
	
	public var data:BitmapData;
}