package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import xlib.framework.Application;
	import xlib.framework.components.AssetsWrapper;
	import xlib.framework.components.SkinWrapper;
	import xlib.framework.events.UIEvent;
	
	[SWF(frameRate="30")]
	public class SkinRendererDemo extends Application
	{
		[Embed(source="../../assets/ui/img.jpg")]
		private var source:Class;
		
		private var skin:AssetsWrapper = new AssetsWrapper();
		
		private var skinWrapper:SkinWrapper;
		
		public function SkinRendererDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			skin.scale9Rect = new Rectangle(71, 73, 71, 73);
			skin.useRepeat = false;
			skin.bitmapData = (new source()).bitmapData;
			
			skinWrapper = new SkinWrapper();
			skinWrapper.addEventListener(UIEvent.UPDATE_COMPLETE, onComplete);
			skinWrapper.width = 500;
			skinWrapper.height = 500;
			skinWrapper.skin = skin;
			this.addChild(skinWrapper);
			
			skinWrapper.showBorder = true;
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		protected function onComplete(event:UIEvent):void
		{
			trace(skinWrapper.width, skinWrapper.height);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			skinWrapper.width-=10;
			skinWrapper.height-=10;
		}
	}
}