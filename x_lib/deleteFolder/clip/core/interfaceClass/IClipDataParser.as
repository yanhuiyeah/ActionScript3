package xlib.extension.display.clip.core.interfaceClass
{
	/**
	 * IClip数据源解析器
	 * @author yeah
	 */	
	public interface IClipDataParser
	{
		/**
		 *解析 
		 * @param $source 待解析数据
		 * @param $callBack 待解完成后的回调 参数：IClipFrameDataList（解析后的数据）
		 * @param $cache	 true 缓存数据 false 缓存配置 
		 * @return 				解析后的IClipFrameDataList
		 */		
		function parser($source:Object, $callBack:Function, $cache:Boolean):void;
	}
}