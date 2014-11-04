package xlib.extension.display.clip.insterfaces
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	/**
	 *clip帧数据接口 
	 * @author yeah
	 */	
	public interface IFrameData extends IEventDispatcher
	{
		/**
		 *本帧在序列帧中的索引 （仅用于排序，此值不可信）
		 */		
		function get frameIndex():int;
		function set frameIndex($value:int):void;
		
		/**
		 *数据 
		 * @return 
		 */		
		function get data():Object;
		function set data($value:Object):void;
		
		/**
		 *销毁
		 */		
		function destroy():void;
	}
}