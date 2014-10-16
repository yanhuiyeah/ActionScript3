package
{
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import xlib.framework.core.Global;
	import xlib.framework.xlib_internal;
	
	use namespace xlib_internal;
	[SWF(frameRate="25")]
	public class x_lib_case extends Sprite
	{
		public function x_lib_case()
		{
			
			total = getTimer();
			ttt = total;
//			var s:Shape = new Shape();
//			s.addEventListener(Event.ENTER_FRAME, testssss);
//			return;
			Global.instance.initGlobal(stage);
			
//			for(var i:int = 0; i < 100; i++)
//			{
//				Global.instance.tick.doDuration(function (str:String):void
//				{
//					trace(str, getTimer());
//				}, 100, 1, [i]);
//			}
//			Global.instance.tick.doDuration(testssss, 100);
//			Global.instance.tick.doDuration(testssss, 200);
			Global.instance.tick.doDuration(testssss, 300);
			
		}
		
		private var ttt:int;
		private var total:int;
		private var i:int;
		private function testssss($e:Event = null):void
		{
			i++;
			var c:int = getTimer();
			var delay:int = (c - total)/i;
			trace("平均：", delay, "当前：", c - ttt);
			ttt = c;
		}
	}
}