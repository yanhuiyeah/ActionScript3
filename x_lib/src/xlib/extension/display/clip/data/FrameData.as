package xlib.extension.display.clip.data
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import xlib.extension.display.clip.insterfaces.IFrameData;
	import xlib.framework.core.LazyDispatcher;
	
	/**
	 *帧默认数据 
	 * @author yeah
	 */	
	public class FrameData extends LazyDispatcher implements IFrameData
	{
		public function FrameData($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		private var _offset:Point;
		public function get offset():Point
		{
			return _offset;
		}
		
		public function set offset($value:Point):void
		{
			this._offset = $value;
		}
		
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		
		private var _frameIndex:int;
		public function get frameIndex():int
		{
			return _frameIndex;
		}
		
		public function set frameIndex($value:int):void
		{
			_frameIndex = $value;
		}
		
		override public function destroy():void
		{
			this.data = null;
			this.frameIndex = 0;
			this.offset = null;
		}
	}
}