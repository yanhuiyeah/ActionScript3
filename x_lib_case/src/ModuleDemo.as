package
{
	import flash.display.Sprite;
	
	import xlib.modules.IModule;
	
	public class ModuleDemo extends Sprite implements IModule
	{
		public function ModuleDemo()
		{
			super();
			trace("ModuleDemo");
		}
	}
}