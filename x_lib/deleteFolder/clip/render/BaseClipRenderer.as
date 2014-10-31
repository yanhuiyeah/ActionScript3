package xlib.extension.display.clip.render
{
	import xlib.extension.display.clip.manager.ObjectPool;
	import xlib.extension.display.clip.core.clip_internal;
	import xlib.extension.display.clip.core.interfaceClass.IClipRenderer;
	import xlib.extension.display.clip.data.ClipFrameBitpmapData;
	import xlib.extension.display.clip.event.ClipDataEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	/**
	 *默认渲染器 
	 * @author yeah
	 */	
	public class BaseClipRenderer extends Bitmap implements IClipRenderer
	{
		public function BaseClipRenderer(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		private var _data:ClipFrameBitpmapData;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data($value:Object):void
		{
			if(_data == $value) return;
			
			
			if(_data)
			{
				if(_data.hasEventListener(ClipDataEvent.FRAME_DATA_IS_READY))
				{
					_data.removeEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				}
			}
			
			_data = $value as ClipFrameBitpmapData;
			
			updatePos();
			
			if(!_data)
			{
				this.bitmapData = null;
				return;
			}
			
			if(_data.bitmapData)
			{
				this.bitmapData = _data.bitmapData;
			}
			else
			{
				_data.addEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
			}
		}
		
		public function get self():DisplayObject
		{
			return this;
		}
		
		/**
		 *外部设置的x 
		 */		
		private var explicit_x:Number = 0;
		
		/**
		 *外部设置的y
		 */		
		private var explicit_y:Number = 0;
		
		public function move($x:Number, $y:Number):void
		{
			explicit_x = $x;
			explicit_y = $y;
			updatePos();
		}
		
		/**
		 *更新位置 
		 */		
		protected function updatePos():void
		{
			if(data && data.offset)
			{
				this.x = explicit_x + data.offset.x;
				this.y = explicit_y + data.offset.y;
			}
			else
			{
				this.x = explicit_x;
				this.y = explicit_y;
			}
		}
		
		public function destroy():void
		{
			explicit_x = 0;
			explicit_y = 0;
			
			if(data)
			{
				if(data.hasEventListener(ClipDataEvent.FRAME_DATA_IS_READY))
				{
					data.removeEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				}
				data.destroy(true);
				_data = null;
			}
			
			this.bitmapData = null;
			
			ObjectPool.instance.push(this);
		}
		
		/**
		 * frameDataIsReady
		 * @param event
		 */		
		private function frameDataIsReady($e:ClipDataEvent):void
		{
			var frameData:ClipFrameBitpmapData = $e.data as ClipFrameBitpmapData;
			if(frameData)
			{
				frameData.removeEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				this.bitmapData = frameData.bitmapData;
			}
			else
			{
				this.bitmapData = null;
			}
		}
	}
}