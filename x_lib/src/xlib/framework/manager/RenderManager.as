package xlib.framework.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import xlib.framework.core.Global;
	import xlib.framework.core.IInvalidateElement;
	import xlib.framework.manager.supportClasses.IRenderManager;
	import xlib.framework.manager.supportClasses.RenderQueue;
	
	/**
	 * 延时生效布局生效渲染管理器
	 * @author yeah
	 */	
	public class RenderManager extends EventDispatcher implements IRenderManager
	{
		public function RenderManager()
		{
			super(null);
			propertiesQueue = new RenderQueue();
			sizeQueue = new RenderQueue();
			displayListQueue = new RenderQueue();
			completeQueue = new RenderQueue();
		}
		
		/***有属性失效*/		
		private var propertiesDirty:Boolean = false;
		
		/***属性失效队列*/		
		private var propertiesQueue:RenderQueue;
		
		/***有度量失效*/		
		private var sizeDirty:Boolean = false;
		
		/***度量失效队列*/		
		private var sizeQueue:RenderQueue;
		
		/***有更新显示列表失效*/		
		private var displayListDirty:Boolean = false;
		
		/***更新显示列表队列*/		
		private var displayListQueue:RenderQueue;
		
		/**执行完布局渲染的队列*/
		private var completeQueue:RenderQueue;
		
		
		public function invalidateProperties($element:IInvalidateElement):void
		{
			if(!propertiesDirty)
			{
				propertiesDirty = true;
				invalidate();
			}
			propertiesQueue.push($element);
		}
		
		public function invalidateSize($element:IInvalidateElement):void
		{
			if(!sizeDirty)
			{
				sizeDirty = true;
				invalidate();
			}
			sizeQueue.push($element);
		}
		
		public function invalidateDisplayList($element:IInvalidateElement):void
		{
			if(!displayListDirty)
			{
				displayListDirty = true;
				invalidate();
			}
			displayListQueue.push($element);
		}
		
		/**
		 * 属性生效
		 */		
		private function validateProperties():void
		{
			if(!propertiesDirty) return;
		}
		
		/**
		 *度量生效 
		 */		
		private function validateSize():void
		{
			
		}
		
		/**
		 *更新显示列表生效 
		 */		
		private function validateDisplayList():void
		{
			
		}
		
		public function validateNow():void
		{
			if(!invalidateDirty) return;
			
			validateProperties();
			validateSize();
			validateDisplayList();
			
			if(propertiesDirty || sizeDirty || displayListDirty)
			{
				validateNow();
				return;
			}
			
			
		}
		
		/**
		 *无实现，禁止调用 
		 * @param $element
		 */		
		public function validateElement($element:IInvalidateElement):void
		{
		}
		
		
		/**
		 *失效标志位 
		 */		
		private var invalidateDirty:Boolean = false; 
		
		/**
		 *失效，延时到下一个Render或者下一帧生效 
		 */		
		private function invalidate():void
		{
			if(invalidateDirty) return;
			Global.instance.stage.addEventListener(Event.RENDER, validate);
			Global.instance.stage.addEventListener(Event.ENTER_FRAME, validate);
			Global.instance.stage.invalidate();
			invalidateDirty = true;
		}
		
		/**
		 *生效 
		 * @param $e
		 */		
		private function validate($e:Event):void
		{
			Global.instance.stage.removeEventListener(Event.RENDER, validate);
			Global.instance.stage.removeEventListener(Event.ENTER_FRAME, validate);
			validateNow();
			invalidateDirty = false;
		}
		
		private static var _instance:RenderManager;

		/**
		 *唯一实例 
		 */
		public static function get instance():RenderManager
		{
			if(!_instance)
			{
				_instance = new RenderManager();
			}
			return _instance;
		}

		
	}
}