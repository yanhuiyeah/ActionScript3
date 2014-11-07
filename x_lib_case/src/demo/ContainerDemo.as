package demo
{
	import demo.items.ComponentOBJ;
	
	import flash.events.MouseEvent;
	
	import xlib.framework.Application;
	import xlib.framework.components.Container;
	import xlib.framework.manager.layout.DefaultLayout;
	
	public class ContainerDemo extends Application
	{
		
		private var c:Container;
		
		public function ContainerDemo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			

			c = new Container();
			c.showBorder = true;
			c.width = 500;
			c.height = 500;
			c.layout = new DefaultLayout();
			this.addChild(c);
			
			var a:ComponentOBJ = new ComponentOBJ();
			a.left = 10;
			a.right = 10;
			a.height = 100;
			a.verticalCenter = 0;
			c.addChild(a);
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			this.removeChild(c);
			c = null;
		}
	}
}