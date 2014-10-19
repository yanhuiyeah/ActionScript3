package
{
	import flash.display.Sprite;
	
	import xlib.modules.IModule;
	
	public class ModuleDemo extends Sprite implements IModule
	{
		public function ModuleDemo()
		{
			super();
			this.graphics.beginFill(0x0000ff);
			this.graphics.drawRect(0, 0, 100,100);
			this.graphics.endFill();
			trace("ModuleDemo");
		}
	}
}