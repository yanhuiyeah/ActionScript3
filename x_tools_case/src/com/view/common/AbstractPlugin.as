package com.view.common
{
	import flash.errors.IllegalOperationError;
	
	import mx.core.IVisualElementContainer;
	
	import spark.components.BorderContainer;
	import com.core.IPlugin;
	
	public class AbstractPlugin extends BorderContainer implements IPlugin
	{
		public function AbstractPlugin()
		{
			super();
			horizontalCenter = 0;
			verticalCenter = 0;
		}
		
		public function get pluginID():String
		{
			throw new IllegalOperationError("pluginID必须覆盖");
		}
		
		public function get pluginName():String
		{
			throw new IllegalOperationError("pluginID必须覆盖");
		}
		
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data($value:Object):void
		{
			this._data = $value;
		}
		
		private var _installed:Boolean = false;
		public function get installed():Boolean
		{
			return _installed;
		}
		
		public function install($parent:IVisualElementContainer):void
		{
			if(_installed) return;
			_installed = true;
			$parent.addElement(this);
		}
		
		public function uninstall():void
		{
			if(!_installed) return;
			if(parent && parent is IVisualElementContainer)
			{
				IVisualElementContainer(parent).removeElement(this);
			}
		}
	}
}