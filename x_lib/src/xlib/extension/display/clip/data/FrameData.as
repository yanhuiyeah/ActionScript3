package xlib.extension.display.clip.data
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import xlib.extension.display.clip.insterfaces.IFrameData;
	import xlib.framework.core.LazyDispatcher;
	
	public class FrameData extends LazyDispatcher implements IFrameData
	{
		public function FrameData($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		public function get offset():Point
		{
			return null;
		}
		
		public function set offset($value:Point):void
		{
		}
		
		public function get frameIndex():int
		{
			return 0;
		}
		
		public function set frameIndex($value:int):void
		{
		}
		
		public function destroy():void
		{
		}
	}
}