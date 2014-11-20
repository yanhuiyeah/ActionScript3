package xlib.framework
{
	import xlib.framework.components.Container;
	import xlib.framework.core.Global;
	import xlib.framework.manager.DefaultSkinParser;
	import xlib.framework.manager.Injector;
	import xlib.framework.manager.RenderManager;
	import xlib.framework.manager.supportClasses.IRenderManager;
	import xlib.framework.manager.supportClasses.ISkinParser;
	
	use namespace xlib_internal;
	
	/**
	 *application
	 * @author yeah
	 */	
	public class Application extends Container
	{
		public function Application()
		{
			//提前注入一些特定的管理器
			Injector.instance.inject(IRenderManager, RenderManager.instance);
			Injector.instance.inject(ISkinParser, new DefaultSkinParser());
			
			
			Global.instance.initGlobal(stage);
			super();
		}
	}
}