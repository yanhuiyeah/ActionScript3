package xlib.extension.display.clip
{
	import flash.utils.getQualifiedClassName;
	
	import xlib.extension.display.clip.core.AbstractClip;
	import xlib.extension.display.clip.manager.ClipManager;
	import xlib.extension.display.clip.core.interfaceClass.IClip;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.core.interfaceClass.IClipRenderer;
	import xlib.extension.display.clip.event.ClipEvent;
	import yxh.xlib.framework.core.XTimer;
	
	/**
	 *IClip基类
	 * 如果source已经准备好 不需要等待处理 请优先使用BaseClip
	 * @author yeah
	 */	
	public class BaseClip extends AbstractClip
	{
		public function BaseClip($source:IClipFrameDataList = null)
		{
			super();
			if($source)
			{
				this.source = $source;
			}
		}
		
		override protected function getClipReadiness():Boolean
		{
			return (super.getClipReadiness() && visible && alpha > 0); 
		}
		
		override public function set visible(value:Boolean):void
		{
			if(super.visible == value) return;
			super.visible = value;
			checkReadiness();
		}
		
		override public function set alpha(value:Number):void
		{
			if(super.alpha == value) return;
			super.alpha = value;
			checkReadiness();
		}
		
		//==================override======================
		override protected function onFrame():void
		{
			super.onFrame();
			onDispatcher(ClipEvent.FRAME);
		}
		
		override protected function onRepeat():void
		{
			super.onRepeat();
			onDispatcher(ClipEvent.REPEAT);
		}
		
		override protected function onComplete():void
		{
			onDispatcher(ClipEvent.COMPLETE);
			super.onComplete();
		}
		
		//=====================abstract===================
		override protected function connectFrame():Boolean
		{
			var flag:Boolean = super.connectFrame();
			if(!flag) return flag;
			XTimer.instance.doReviseDuration(this.nextFrame, this.frameDuration);
			return true;
		}
		
		override protected function cutFrame():Boolean
		{
			var flag:Boolean = super.cutFrame();
			if(!flag) return flag;
			XTimer.instance.clean(this.nextFrame);
			return true;
		}
		
		/**
		 *在外部没有调用 set clipRender()设置IClipRender时会调用此方法创建IClipRender 
		 * 请优先使用ClipManager.register注册后 重写getClipRenderKey()来创建
		 * 比如:register(IClip, ClipDefaultRenderer);  重写getClipRenderKey() return getDefinitionByName(IClip)
		 * @return 
		 */		
		override protected function createDefaultClipRender():IClipRenderer
		{
			return ClipManager.instance.getClipRenderer(getClipRenderKey());
		}
		
		//=============================================
		/**
		 *返回ClipManager注册ClipRender的键 
		 * 子类可覆盖此方法 以便创建不同的IClipRenderer
		 */		
		protected function getClipRenderKey():Object
		{
			return getQualifiedClassName(IClip);
		}
		
		/**
		 *派发事件 
		 * @param $type 类型
		 */		
		protected function onDispatcher($type:String):void
		{
			this.dispatchEvent(new ClipEvent($type));	
		}
	}
}