package xlib.extension.display.clip.data
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *解析后的数据
	 * 存储Rectangle 或者 bitmapdata		两者互斥
	 * @author yeah
	 */	
	public class ClipParseredData extends ClipFrameBitpmapData
	{
		public function ClipParseredData($offset:Point = null, $dispatcher:EventDispatcher = null)
		{
			super(null, $offset, false, $dispatcher);
		}
		
		private var _rect:Rectangle;

		/**
		 *Rectangle 所在区域
		 * @return 
		 */		
		public function get rect():Rectangle
		{
			return _rect;
		}

		public function set rect(value:Rectangle):void
		{
			destroyBmd();
			if(this._rect == value) return;
			this._rect = value;
		}
		
		override public function setBitmapData($bitmapData:BitmapData, $useClone:Boolean=false, $destroyOldDispather:Boolean=false):void
		{
			super.setBitmapData($bitmapData, $useClone, $destroyOldDispather);
			this._rect = null;
		}
		
		/**
		 *销毁btimapdata 
		 */		
		private function destroyBmd():void
		{
			if(!bitmapData) return;
			super.destroy(false);
		}
		
		override public function destroy($cleanDispather:Boolean):void
		{
			super.destroy($cleanDispather);
			this._rect = null;
		}
	}
}