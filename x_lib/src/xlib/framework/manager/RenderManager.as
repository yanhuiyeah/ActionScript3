package xlib.framework.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import xlib.framework.core.Global;
	import xlib.framework.core.interfaces.IInvalidateElement;
	import xlib.framework.events.TickEvent;
	import xlib.framework.events.UIEvent;
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
			
			var element:IInvalidateElement = propertiesQueue.shift();
			while(element)
			{
				element.validateProperties();
				if(!element.updateCompletePendingFlag)
				{
					element.updateCompletePendingFlag = true;
					completeQueue.push(element);
				}
				element = propertiesQueue.shift();
			}
			
			if(propertiesQueue.isEmperty())
			{
				propertiesDirty = false;
			}
		}
		
		/**
		 *度量生效 
		 */		
		private function validateSize():void
		{
			if(!sizeDirty) return;
			
			var element:IInvalidateElement = sizeQueue.pop();
			while(element)
			{
				element.validateSize();
				if(!element.updateCompletePendingFlag)
				{
					element.updateCompletePendingFlag = true;
					completeQueue.push(element);
				}
				element = sizeQueue.pop();
			}
			
			if(sizeQueue.isEmperty())
			{
				sizeDirty = false;
			}
		}
		
		/**
		 *更新显示列表生效 
		 */		
		private function validateDisplayList():void
		{
			if(!displayListDirty) return;
			
			var element:IInvalidateElement = displayListQueue.shift();
			while(element)
			{
				element.validateDisplayList();
				if(!element.updateCompletePendingFlag)
				{
					element.updateCompletePendingFlag = true;
					completeQueue.push(element);
				}
				element = displayListQueue.shift();
			}
			
			if(displayListQueue.isEmperty())
			{
				displayListDirty = false;
			}
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
			
			invalidateDirty = false;
			
			var element:IInvalidateElement = completeQueue.pop();
			while(element)
			{
				if(!element.initialized)
				{
					element.initialized = true;
				}
				
				if(element.hasEventListener(UIEvent.UPDATE_COMPLETE))
				{
					element.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));	
				}
				
				element.updateCompletePendingFlag = false;
				element = completeQueue.pop();
			}
			
			if(this.hasEventListener(UIEvent.UPDATE_COMPLETE))
			{
				this.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
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
			invalidateDirty = true;
			Global.instance.stage.addEventListener(Event.RENDER, validate);
			Global.instance.tick.addEventListener(TickEvent.FRAME_TICK, validate);
			Global.instance.stage.invalidate();
		}
		
		/**
		 *生效 
		 * @param $e
		 */		
		private function validate($e:Event):void
		{
			Global.instance.stage.removeEventListener(Event.RENDER, validate);
			Global.instance.tick.removeEventListener(TickEvent.FRAME_TICK, validate);
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