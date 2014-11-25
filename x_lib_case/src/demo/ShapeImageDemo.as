package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import xlib.framework.Application;
	import xlib.framework.components.AssetsWrapper;
	import xlib.framework.events.UIEvent;
	
	
	public class ShapeImageDemo extends Application
	{
		[Embed(source="../../assets/ui/img.jpg")]
		private var source:Class;
		
		private var img:AssetsWrapper
		
		public function ShapeImageDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			img = new AssetsWrapper();
			img.scale9Rect = new Rectangle(71, 73, 71, 73);
			img.useRepeat = false;
			img.bitmapData = (new source()).bitmapData;
			img.validateNow();
			this.addChild(img);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onComplete(event:UIEvent):void
		{
			trace(img.width, img.height);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			img.width += 20;
			img.height += 20;
			img.validateNow();
		}
	}
}