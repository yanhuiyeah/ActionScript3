package xlib.framework.manager.supportClasses
{
	/**
	 *skin 解析器 接口
	 * @author yeah
	 */	
	public interface ISkinParser
	{
		/**
		 *解析皮肤 
		 * @param $skin
		 * @param $callBack
		 */		
		function parser($skin:Object, $callBack:Function):void;
	}
}