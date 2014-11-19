package demo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import display.clip.Clip;
	import display.clip.data.FrameData;
	import display.clip.insterfaces.IClip;
	import display.clip.insterfaces.IFrameData;
	import xlib.framework.Application;
	
	public class ClipDemo2 extends Application
	{
		public function ClipDemo2()
		{
			super();
		}
		
		private var clip:IClip;
		override protected function createChildren():void
		{
			super.createChildren();
			clip = new Clip();
			clip.frameDuration = 200;
			clip.source = new cd2();
			this.addChild(clip as DisplayObject);
			(clip as DisplayObject).scaleX = .3;
			(clip as DisplayObject).scaleY = .3;
			clip.play();
		}
	}
}



//================================================
import flash.display.BitmapData;
import flash.utils.ByteArray;

import display.clip.data.ClipParserData;
import display.clip.data.ClipData;



class cd2 extends ClipParserData
{
	public function cd2()
	{
		super();
		
		var xmlBytes:ByteArray = new config() as ByteArray;
		var xml:XML = new XML(xmlBytes.readUTFBytes(xmlBytes.bytesAvailable));
		var bmd:BitmapData = (new img()).bitmapData;
		parserData(bmd, xml, "name");
	}
	
	[Embed(source="../../assets/avatar/hero.xml", mimeType="application/octet-stream")]
	private var config:Class;

	[Embed(source="../../assets/avatar/hero.png")]
	private var img:Class;
}