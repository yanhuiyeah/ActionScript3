package xlib.framework.core
{
	import flash.display.Stage;
	
	import xlib.framework.xlib_internal;
	import xlib.framework.manager.Injector;
	import xlib.framework.manager.TickManager;
	import xlib.framework.manager.supportClasses.IRenderManager;
	
	use namespace xlib_internal;
	
	/**
	 *全局控制 （单例）
	 * @author yeah
	 */	
	public class Global
	{
		
		private var _renderManager:IRenderManager;

		/**
		 *延时生效布局生效渲染管理器 
		 */		
		public function get renderManager():IRenderManager
		{
			return _renderManager;
		}
		
		private var _tick:TickManager;
		/**
		 *tick 
		 */
		public function get tick():TickManager
		{
			return _tick;
		}

		private var _stage:Stage;
		/**
		 *舞台 
		 */		
		public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 *初始化 
		 * @param $stage
		 */		
		xlib_internal function initGlobal($stage:Stage):void
		{
			this._stage = $stage;
			this._tick = TickManager.instance;
			this._renderManager = Injector.instance.pull(IRenderManager);
		}
		
		//==================================
		public function Global()
		{
			if(_instance)
			{
				throw new Error("单例类不能被实例化");
			}
		}
		
		private static var _instance:Global;
		/**
		 *globle唯一实例 
		 */		
		public static function get instance():Global
		{
			if(!_instance)
			{
				_instance = new Global();
			}
			return _instance;
		}

	}
}