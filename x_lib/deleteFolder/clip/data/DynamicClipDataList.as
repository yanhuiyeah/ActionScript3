package xlib.extension.display.clip.data
{
	import xlib.extension.display.clip.core.clip_internal;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameData;
	import xlib.extension.display.clip.core.interfaceClass.IDynamicClip;
	import xlib.extension.display.clip.event.ClipDataEvent;
	
	import flash.events.EventDispatcher;
	
	use namespace clip_internal;
	
	
	public class DynamicClipDataList extends ClipFrameDataList implements IDynamicClip
	{
		public function DynamicClipDataList($dispatcher:EventDispatcher=null)
		{
			super($dispatcher);
		}
		
		public function addFrameAt($frameData:IClipFrameData, $index:int=-1):IClipFrameData
		{
			var dataSource:Vector.<IClipFrameData> = _data;
			if($index == -1)
			{
				$index = totalFrame;
			}
			
			if(!dataSource)
			{
				dataSource = new Vector.<IClipFrameData>();
				dataSource[$index] = $frameData;
				data = dataSource;
				return $frameData;
			}
				
			var index:int = getFrameIndex($frameData);
			
			if(index == $index) return $frameData;
			
			if(index == -1)
			{
				index = $index;
			}
			else
			{
				dataSource.splice(index, 1);
				if($index > index)
				{
					$index--;
				}
				index = $index;
			}
			
			dataSource.splice(index, 0, $frameData);
			refresh();
			return $frameData;
		}
		
		public function removeFrameAt($index:int):IClipFrameData
		{
			if(totalFrame <= $index)
			{
				throw new Error("$index:"+$index+"超出范围:" + totalFrame);
			}
			
			var frameData:IClipFrameData = getFrameData($index);
			if(frameData)
			{
				_data.splice($index, 1);
				refresh();
			}
			return frameData;
		}
		
		public function removeFrame($frameData:IClipFrameData):IClipFrameData
		{
			var index:int = getFrameIndex($frameData);
			if(index == -1) 
			{
				throw new Error("数据源中不存在" +$frameData);
			}
			_data.splice(index, 1);
			refresh();
			return $frameData;
		}
		
		public function replaceFrameAt($frameData:IClipFrameData, $index:int):void
		{
			if($index >= totalFrame || $index < 0) 
			{
				throw new Error("$index:"+$index+"超出范围:0~" + totalFrame);
			}
			
			var index:int = getFrameIndex($frameData);
			if(index == $index) return;
			
			if(index == -1)
			{
				_data.splice($index, 1, $frameData);
			}
			else
			{
				var oldData:IClipFrameData = getFrameData($index);
				_data[$index] = $frameData;
				_data[index] = oldData;
			}
			
			refresh();
		}
	}
}