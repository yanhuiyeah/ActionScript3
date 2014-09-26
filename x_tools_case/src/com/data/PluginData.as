package com.data
{
	import com.core.IExhibitionPlugin;
	import com.core.IPlugin;

	public class PluginData
	{
		public var tools:IPlugin;
		public var exhibition:IExhibitionPlugin;
		public function desroty():void
		{
			this.tools = null;
			this.exhibition = null;
		}
		public function PluginData()
		{
		}
	}
}