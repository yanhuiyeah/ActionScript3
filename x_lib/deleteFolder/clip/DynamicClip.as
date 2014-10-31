package xlib.extension.display.clip
{
	import flash.utils.getQualifiedClassName;
	
	import xlib.extension.display.clip.core.clip_internal;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameData;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.core.interfaceClass.IDynamicClip;
	
	use namespace clip_internal;
	
	/**
	 *可以动态增减帧的clip 
	 * @author yeah
	 */	
	public class DynamicClip extends BaseClip implements IDynamicClip
	{
		public function DynamicClip($source:IClipFrameDataList=null)
		{
			super($source);
		}
		
		public function addFrameAt($frameData:IClipFrameData, $index:int=-1):IClipFrameData
		{
			checkSource();
			IDynamicClip(source).addFrameAt($frameData, $index);
			updateWhenSourceChanged();
			return $frameData;
		}
		
		public function removeFrameAt($index:int):IClipFrameData
		{
			checkSource();
			var frameData:IClipFrameData = IDynamicClip(source).removeFrameAt($index);
			updateWhenSourceChanged();
			return frameData;
		}
		
		public function removeFrame($frameData:IClipFrameData):IClipFrameData
		{
			checkSource();
			var frameData:IClipFrameData = IDynamicClip(source).removeFrame($frameData);
			updateWhenSourceChanged();
			return frameData;
		}
		
		public function replaceFrameAt($frameData:IClipFrameData, $index:int):void
		{
			checkSource();
			IDynamicClip(source).replaceFrameAt($frameData, $index);
			updateWhenSourceChanged();
		}
		
		/**
		 *当source内容发生改变、更新当前帧 
		 */		
		private function updateWhenSourceChanged():void
		{
			_totalFrame = source ? source.totalFrame : 0;
			if(!frameData || !source.hasFrameData(frameData)) return;
			setFrameIndex(source.getFrameIndex(frameData));
		}
		
		
		/**
		 *检测 checkSource
		 */		
		private function checkSource():void
		{
			if(!source || !(source is IDynamicClip))
			{
				throw new Error("source必须是:" + getQualifiedClassName(IDynamicClip));
			}
			else
			{
				
			}
		}
	}
}