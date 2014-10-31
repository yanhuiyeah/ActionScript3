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
		 * 偏移量（在每一帧对齐结束后位置偏移量。在原来位置的基础上+-而不是直接赋值） 
		 * @return 
		 */		
		function get offset():Point;
		function set offset($value:Point):void;
		
		/**
		 *本帧在序列帧中的索引 （仅用于排序，此值不可信）
		 */		
		function get frameIndex():int;
		function set frameIndex($value:int):void;
		
		/**
		 *销毁
		 */		
		function destroy():void;
	}
}