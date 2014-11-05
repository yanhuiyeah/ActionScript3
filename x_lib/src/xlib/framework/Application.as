package xlib.framework
{
	import xlib.framework.components.Container;
	import xlib.framework.core.Component;
	import xlib.framework.core.Global;
	
	use namespace xlib_internal;
	
	/**
	 *application
	 * @author yeah
	 */	
	public class Application extends Container
	{
		public function Application()
		{
			Global.instance.initGlobal(stage);
			super();
		}
	}
}