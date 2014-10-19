package xlib.modules
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	/**
	 *模块信息 
	 * @author yeah
	 */	
	public class ModuleInfo extends EventDispatcher implements IModuleInfo
	{
		public function ModuleInfo($url:String, $dispatcher:IEventDispatcher=null)
		{
			super($dispatcher);
			this._url = $url;
		}
		
		private var _url:String;
		public function get url():String
		{
			return _url;
		}
		
		private var _loaded:Boolean = false;
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		private var _module:IModule;
		public function get module():IModule
		{
			return _module;
		}
		
		/**
		 *laoder 
		 */		
		private var loader:Loader;
		
		public function loadModule($applicationDomain:ApplicationDomain=null, $securityDomain:SecurityDomain=null, $bytes:ByteArray=null):void
		{
			if(loader)
			{
				return;
			}
			
			destroyLoader();
			
			_loaded = true;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoad);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoad);
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoad);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = $applicationDomain ? $applicationDomain : ApplicationDomain.currentDomain;
			if ($securityDomain != null && Security.sandboxType == Security.REMOTE)
			{
//				context.securityDomain = $securityDomain ? $securityDomain : SecurityDomain.currentDomain);
				context.securityDomain = $securityDomain;
			}
			if($bytes)
			{
				loader.loadBytes($bytes, context);
				return;
			}
			
			if(url)
			{
				loader.load(new URLRequest(url), context);
			}
			
		}
		
		public function unloadModule():void
		{
			destroyLoader();
			
			if(loaded)
			{
				this.dispatchEvent(new Event(Event.UNLOAD));
			}
			
			_loaded = false;
			
			if(_module)
			{
				_module = null;
			}
		}
		
		/**
		 *加载过程
		 * @param $e
		 */		
		private function onLoad($e:Event):void
		{
			if($e.type == Event.COMPLETE)
			{
				_module = $e.currentTarget.content as IModule;
				destroyLoader();
			}
			dispatchEvent($e);
		}
		
		/**
		 *销毁loader 
		 */		
		private function destroyLoader():void
		{
			if(!loader) return;
			
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoad);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoad);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoad);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
			loader.unload();
			loader = null;
		}
	}
}