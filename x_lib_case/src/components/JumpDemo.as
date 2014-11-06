package components
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import xlib.extension.display.clip.events.ClipEvent;
	import xlib.extension.display.clip.insterfaces.IClip;
	import xlib.extension.display.jump.MovingItem;
	import xlib.framework.Application;
	import xlib.framework.core.Component;
	
	public class JumpDemo extends Application
	{
		public function JumpDemo()
		{
			super();
		}
		private var clip:MovingItem;
		override protected function createChildren():void
		{
			super.createChildren();
			clip = new MovingItem();
			clip.frameDuration = 200;
			clip.source = new cd3();
			clip.addEventListener(ClipEvent.FRAME, onframe);
			this.addChild(clip as DisplayObject);
			(clip as DisplayObject).scaleX = (clip as DisplayObject).scaleY = .3;
			clip.play("walk");
			clip.go();
			clip.horizontal.forward = false;
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyup);
		}
		
		protected function onKeyup(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
					clip.vertical.speed = 30;
					clip.vertical.forward = true;
					break;
				case Keyboard.LEFT:
					clip.horizontal.forward = true;
					break;
				case Keyboard.RIGHT:
					clip.horizontal.forward = false;
					break;
				case Keyboard.ENTER:
					clip.y = 600;
					break;
			}
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