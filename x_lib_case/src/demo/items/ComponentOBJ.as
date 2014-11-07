package demo.items
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import xlib.framework.core.Component;
	
	public class ComponentOBJ extends Component
	{
		public function ComponentOBJ()
		{
			super();
		}
		
		override protected function measure():void
		{
			measuredWidth = 10;
			measuredHeight = 10;
		}
		
		override protected function updateDisplayList($width:Number, $height:Number):void
		{
			super.updateDisplayList($width, $height);
			this.graphics.beginFill(Math.random() * 0xffffff, .5);
			this.graphics.drawRect(0, 0, $width||0, $height||0);
			this.graphics.endFill();
		}
	}
}