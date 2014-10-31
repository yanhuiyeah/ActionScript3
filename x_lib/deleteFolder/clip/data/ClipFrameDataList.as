package xlib.extension.display.clip.data
{
	
	import xlib.extension.display.clip.core.LazyDispatcher;
	import xlib.extension.display.clip.core.clip_internal;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameData;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.event.ClipDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	use namespace clip_internal;
	
	public class ClipFrameDataList extends LazyDispatcher implements IClipFrameDataList
	{
		public function ClipFrameDataList($dispatcher:EventDispatcher = null)
		{
			super($dispatcher);
		}
		
		clip_internal var _totalFrame:int;
		public function get totalFrame():int
		{
			return this._totalFrame;
		}
		
		clip_internal var _data:Vector.<IClipFrameData>;
		public function set data(value:Vector.<IClipFrameData>):void
		{
			if(_data == value) return;
			this._data = value.concat();
			refresh();
		}
		
		public function getFrameData($index:int):IClipFrameData
		{
			if(totalFrame < 1) return null;
			return _data[$index];
		}
		
		public function getFrameIndex($frameData:IClipFrameData):int
		{
			if(totalFrame < 1) return -1;
			return _data.indexOf($frameData);
		}
		
		public function hasFrameData($frameData:IClipFrameData):Boolean
		{
			return (getFrameIndex($frameData) != -1);
		}
		
		public function refresh():void
		{
			_totalFrame = _data ? _data.length : 0;
			dispatchEvent(new ClipDataEvent(ClipDataEvent.FRAME_DATA_LIST_REFRESH));
		}
		
		public function destroy():void
		{
			if(_data)
			{
				_data.length = 0;
				_totalFrame = 0;
				_data = null;
			}
			
			this._dispatcher = null;
		}
	}
}