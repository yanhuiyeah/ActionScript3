package
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import xlib.framework.core.Global;
	import xlib.framework.xlib_internal;
	import xlib.modules.IModuleInfo;
	import xlib.modules.ModuleManager;
	
	use namespace xlib_internal;
	[SWF(frameRate="25")]
	public class x_lib_case extends Sprite
	{
		public function x_lib_case()
		{
			var bytes:ByteArray = new ByteArray();
			trace(bytes.position);
			bytes.writeInt(10);
			trace(bytes.position);
			bytes.position = 0;
			trace(bytes.position);
			bytes.readInt();
			trace(bytes.position);
			return;
			var moduleInfo:IModuleInfo = ModuleManager.instance.getModule("ModuleDemo.swf");
			moduleInfo.addEventListener(Event.COMPLETE, onComplete);
			moduleInfo.loadModule();
		}
		
		private function onComplete($e:Event):void
		{
			var moduleInfo:IModuleInfo = ModuleManager.instance.getModule("ModuleDemo.swf");
			this.addChild(moduleInfo.module as DisplayObject);
			trace("onComplete");
			stage.addEventListener(MouseEvent.CLICK, onclick);
		}
		
		protected function onclick(event:MouseEvent):void
		{
			var moduleInfo:IModuleInfo = ModuleManager.instance.getModule("ModuleDemo.swf");
			moduleInfo.addEventListener(Event.UNLOAD, onUnload);
			moduleInfo.unloadModule();
		}
		
		private function onUnload($e:Event):void
		{
			trace("unloadModule");
			var moduleInfo:IModuleInfo = ModuleManager.instance.getModule("ModuleDemo.swf");
			this.removeChild(moduleInfo.module as DisplayObject);
		}
	}
}