package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import xlib.framework.Application;
	import xlib.framework.events.UIEvent;
	import xlib.framework.components.Wapper
	
	
	public class WapperDemo extends Application
	{
		[Embed(source="../../assets/ui/img.jpg")]
		private var source2:Class;
		
		private var img:Wapper;
		
		public function WapperDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			img = new Wapper();
			img.addEventListener(UIEvent.UPDATE_COMPLETE, onComplete);
			img.scale9Rect = new Rectangle(71, 73, 71, 73);
			img.useRepeat = false;
			img.bitmapData = (new source2()).bitmapData;
			this.addChild(img);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onComplete(event:UIEvent):void
		{
			trace(event.target, img.width, img.height);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			img.width += 20;
			img.height += 20;
		}
	}
}