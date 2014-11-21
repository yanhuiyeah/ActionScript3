package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import xlib.framework.Application;
	import xlib.framework.components.ShapeImage;
	
	
	public class ShapeImageDemo extends Application
	{
		[Embed(source="../../assets/ui/img.jpg")]
		private var source:Class;
		
		private var img:ShapeImage
		
		public function ShapeImageDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			img = new ShapeImage();
			img.scale9Rect = new Rectangle(71, 73, 71, 73);
			img.useRepeat = false;
			img.width = 500;
			img.source = (new source()).bitmapData;
			this.addChild(img);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
		}
	}
}