package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import xlib.framework.Application;
	import xlib.framework.components.ShapeImage;
	import xlib.framework.components.SkinRenderer;
	import xlib.framework.events.UIEvent;
	
	
	public class SkinRendererDemo extends Application
	{
		[Embed(source="../../assets/ui/img.jpg")]
		private var source:Class;
		
		private var img:ShapeImage
		
		private var render:SkinRenderer;
		
		public function SkinRendererDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			img = new ShapeImage();
			img.scale9Rect = new Rectangle(71, 73, 71, 73);
			img.useRepeat = false;
			img.bitmapData = (new source()).bitmapData;
			
			render = new SkinRenderer();
			render.addEventListener(UIEvent.UPDATE_COMPLETE, onComplete);
//			render.width = 500;
//			render.height = 500;
			render.skin = img;
			this.addChild(render);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		protected function onComplete(event:UIEvent):void
		{
			trace(render.width, render.height);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			render.width+=10;
		}
	}
}