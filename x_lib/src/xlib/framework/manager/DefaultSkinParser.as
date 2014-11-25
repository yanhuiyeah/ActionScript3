package xlib.framework.manager
{
	import xlib.framework.manager.supportClasses.ISkinParser;
	
	/**
	 *默认的皮肤解析器 
	 * @author yeah
	 */	
	public class DefaultSkinParser implements ISkinParser
	{
		public function DefaultSkinParser()
		{
		}
		
		public function parser($skin:Object, $callBack:Function):void
		{
			$callBack.call(null, $skin);
			trace("DefaultSkinParser--未完待续。。。");
		}
	}
}