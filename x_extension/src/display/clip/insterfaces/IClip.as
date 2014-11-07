package display.clip.insterfaces
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public interface IClip extends IDataFrameLooper
	{
		/**
		 *是否自动播放 默认false<br>
		 */		
		function get autoPlay():Boolean;
		function set autoPlay($value:Boolean):void;
		
		/**stop或者播放完成后是否从显示列表中自动移除，默认为false*/
		function get autoRemoved():Boolean;
		function set autoRemoved($value:Boolean):void;
		
		/**
		 *从显示列表移除后是否自动销毁 默认false
		 */		
		function get autoDestroy():Boolean;
		function set autoDestroy($value:Boolean):void;
		
		
		/***注册点*/		
		function get pivot():Point;
		function set pivot($value:Point):void;
		
		/**
		 *播放 
		 * @param $frameLabel 将要播放的帧标签		null表示当前标签
		 */		
		function play($frameLabel:String = null):void;
		
		/**
		 *停止 
		 */		
		function stop():void;
		
		/**
		 *暂停 
		 */		
		function pause():void;
		
		/**
		 *恢复 
		 */		
		function resume():void;
	}
}