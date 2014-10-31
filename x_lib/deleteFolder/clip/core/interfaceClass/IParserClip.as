package xlib.extension.display.clip.core.interfaceClass
{
	/**
	 *带有解析器的clip
	 * @author yeah
	 */	
	public interface IParserClip
	{
		/**
		 *待解析对象
		 */		
		function get sourceData():Object;
		function set sourceData($value:Object):void;
		
		
		/**
		 *data 解析器 
		 * @return 
		 */		
		function get dataParser():IClipDataParser;
		function set dataParser($value:IClipDataParser):void;
		
		/**
		 *是否缓BitmapData
		 * true:数据解析后缓存BitmapData  clipRender每次都替换data中的BitmapData				（耗内存，省CUP）
		 * false:数据解析后不缓存BitmapData 而是存储配置数据 clipRender每次都根据配置渲染	（耗CUP，省内存）
		 * @default true
		 * @return 
		 */		
		function get cacheBitmapData():Boolean;
		function set cacheBitmapData($value:Boolean):void;
	}
}