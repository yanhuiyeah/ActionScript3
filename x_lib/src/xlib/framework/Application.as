package xlib.framework
{
	import xlib.framework.core.Component;
	import xlib.framework.core.Global;
	
	use namespace xlib_internal;
	
	/**
	 *application
	 * @author yeah
	 */	
	public class Application extends Component
	{
		public function Application()
		{
			Global.instance.initGlobal(stage);
			super();
		}
	}
}