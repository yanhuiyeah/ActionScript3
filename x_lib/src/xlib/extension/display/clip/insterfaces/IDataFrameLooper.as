package xlib.extension.display.clip.insterfaces
{
	/**
	 *带有数据源的帧循环器接口
	 * @author yeah
	 */	
	public interface IDataFrameLooper extends IFrameLooper
	{
		/**
		 *数据源 
		 */		
		function get source():IClipData;
		function set source($value:IClipData):void;
		
		/**当前帧标签, 设置此值当前帧索引变成0*/
		function get frameLabel():String;
		function set frameLabel($value:String):void;
		
		/***当前帧的数据*/		
		function get frameData():IFrameData;
	}
}