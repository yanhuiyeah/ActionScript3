package components
{
	import flash.display.DisplayObject;
	
	import xlib.extension.display.clip.events.ClipEvent;
	import xlib.extension.display.clip.insterfaces.IClip;
	import xlib.extension.display.jump.Speed;
	import xlib.framework.Application;
	import xlib.framework.core.Component;
	
	public class JumpDemo extends Application
	{
		public function JumpDemo()
		{
			super();
		}
		private var clip:Speed;
		override protected function createChildren():void
		{
			super.createChildren();
			clip = new Speed();
			clip.frameDuration = 200;
			clip.source = new cd3();
			clip.addEventListener(ClipEvent.FRAME, onframe);
			this.addChild(clip as DisplayObject);
			(clip as DisplayObject).scaleX = (clip as DisplayObject).scaleY = .3;
			clip.play("walk");
		}
		
		protected function onframe(event:ClipEvent):void
		{
//			clip.self.x++;
		}
	}
}



//================================================
import flash.display.BitmapData;
import flash.utils.ByteArray;

import xlib.extension.display.clip.data.ClipParserData;
import xlib.extension.display.clip.data.ClipData;



class cd3 extends ClipParserData
{
	public function cd3()
	{
		super();
		
		var xmlBytes:ByteArray = new config() as ByteArray;
		var xml:XML = new XML(xmlBytes.readUTFBytes(xmlBytes.bytesAvailable));
		var bmd:BitmapData = (new img()).bitmapData;
		parserData(bmd, xml, "name");
	}
	
	[Embed(source="assets/avatar/hero.xml", mimeType="application/octet-stream")]
	private var config:Class;
	
	[Embed(source="../assets/avatar/hero.png")]
	private var img:Class;
}