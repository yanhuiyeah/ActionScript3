package demo
{
	import display.clip.Clip;
	import display.clip.events.ClipEvent;
	import display.clip.insterfaces.IClip;
	import display.moving.MovingData;
	import display.moving.MovingProxy;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import xlib.framework.Application;
	import xlib.framework.core.Component;
	
	public class JumpDemo extends Application
	{
		public function JumpDemo()
		{
			super();
		}
		private var clip:Clip;
		private var element:MovingProxy;
		override protected function createChildren():void
		{
			super.createChildren();
			clip = new Clip();
			clip.frameDuration = 200;
			clip.source = new cd3();
			clip.addEventListener(ClipEvent.FRAME, onframe);
			this.addChild(clip as DisplayObject);
			(clip as DisplayObject).scaleX = (clip as DisplayObject).scaleY = .3;
			clip.play(0, "walk");
			
			element = new MovingProxy();
			element.target = clip;
			element.frameDuration = 200;
			
			var md:MovingData = new MovingData();
//			md.miniSpeed = 0;
//			md.maxSpeed = 10;
//			element.hData = md;
			
			md = new MovingData();
			md.miniSpeed = 0;
			md.maxSpeed = 10;
			md.accelerate = 1;
			element.vData = md;
			
			element.gotoAndPlay();
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyup);
		}
		
		protected function onKeyup(event:KeyboardEvent):void
		{
//			switch(event.keyCode)
//			{
//				case Keyboard.SPACE:
//					clip.vertical.speed = 50;
//					clip.vertical.rate = -1;
//					break;
//				case Keyboard.LEFT:
//					clip.horizontal.rate = -1;
//					break;
//				case Keyboard.RIGHT:
//					clip.horizontal.rate = 1;
//					break;
//				case Keyboard.ENTER:
//					clip.y = 600;
//					clip.x = 0;
//					clip.vertical.speed = 30;
//					clip.vertical.rate = -1;
//					break;
//			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			
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

import display.clip.data.ClipParserData;
import display.clip.data.ClipData;



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