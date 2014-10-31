package xlib.extension.display.clip.render
{
	import xlib.extension.display.clip.manager.ClipAssetsManager;
	import xlib.extension.display.clip.data.ClipParseredData;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 *通用Clip对应的 clipRender
	 * @author yeah
	 */	
	public class ClipRenderer extends BaseClipRenderer
	{
		public function ClipRenderer(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		private var _parsedKey:Object;

		/**
		 *被解析的数据key 
		 */
		public function get parsedKey():Object
		{
			return _parsedKey;
		}

		/**
		 * @private
		 */
		public function set parsedKey(value:Object):void
		{
			if(_parsedKey == value) return;
			_parsedKey = value;
		}

		
		private var _data:ClipParseredData;
		override public function set data($value:Object):void
		{
			if(data == $value) return;
			this._data = $value as ClipParseredData; 
			if(!_data || !_data.rect) return;
			
			if(!this.bitmapData || this.bitmapData.width != _data.rect.width || this.bitmapData.height == _data.rect.height)
			{
				this.bitmapData = new BitmapData(_data.rect.width, _data.rect.height);
			}
			
			var bmd:BitmapData = ClipAssetsManager.instance.getBitmapData(this.parsedKey);
			this.bitmapData.copyPixels(bmd, _data.rect, new Point());
			updatePos();
		}
		
		override public function get data():Object
		{
			return _data;
		}
	}
}