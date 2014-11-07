package display.clip.insterfaces
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * IClip数据源接口
	 * @author yeah
	 */	
	public interface IClipData extends IEventDispatcher
	{
		/**
		 *帧总数 
		 */		
		function get totalFrame():int;
		
		/**
		 *获取真标签列表 
		 */		
		function get frameLabels():Vector.<String>;
		
		/**
		 *获取帧标签对应的帧数 
		 * @param $frameLabel	帧标签
		 * @return 
		 */		
		function getFrameCount($frameLabel:String = "main"):int;
		
		/**
		 *添加帧数据列表 
		 * @param $frames			帧数据列表
		 * @param $frameLabel	帧标签
		 */		
		function addFrames($frames:Vector.<IFrameData>, $frameLabel:String = "main"):void;
		
		/**
		 *添加帧数据 
		 * @param $frameData
		 * @param $frameLabel
		 */		
		function addFrame($frameData:IFrameData, $frameLabel:String = "main"):void;
		
		/**
		 *根据帧标签移除帧数据 
		 * @param $frameLabel	帧标签，如果是null 则移除所有
		 * @return 						被移除的帧数据列表
		 */		
		function removeFrames($frameLabel:String = "main"):Vector.<IFrameData>;
		
		/**
		 *获取帧标签对应的帧数据列表 
		 * @param $frameLabel	帧标签
		 * @return 
		 */		
		function getFrames($frameLabel:String = "main"):Vector.<IFrameData>;
		
		/**
		 *获取指定标签数据列表中指定索引的帧数据 
		 * @param $index					在帧标签对应数据列表中的索引
		 * @param $frameLabel		帧标签
		 * @return 
		 */		
		function getFrame($index:int, $frameLabel:String ="main"):IFrameData;
		
		/**
		 *是否包含指定帧标签 
		 * @param $frameLabel	 帧标签
		 * @return 
		 */		
		function hasFrameLabel($frameLabel:String):Boolean;
		
		/**
		 *指定真标签下是否含有指定帧数据 
		 * @param $frameData		帧数据
		 * @param $frameLabel	帧标签	null则在所有帧标签中查找
		 * @return 						
		 */		
		function hasFrame($frameData:IFrameData, $frameLabel:String = "main"):Boolean;
		
		
		/**刷新并且派发ClipDataEvent.FRAME_DATA_LIST_REFRESH事件*/
		function refresh():void;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
	}
}