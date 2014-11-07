package display.clip.data
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import display.clip.events.ClipEvent;
	
	
	/**
	 *clip 帧数据 （含有BitmapData类型）
	 * 支持派发事件（数据动态改变时可用）
	 * 如果创建之初BitmapData处于异步加载状态则可以监听ClipDataEvent.FRAME_DATA_IS_READY事件刷新
	 * @author yeah
	 */	
	public class FrameBitpmapData extends FrameData
	{
		public function FrameBitpmapData($bitmapData:BitmapData = null, $offset:Point = null, $useClone:Boolean = false, $dispatcher:EventDispatcher = null)
		{
			super($dispatcher);
			this.offset = $offset;
			setBitmapData($bitmapData, $useClone);
		}
		
		/**是否使用BitmapData的clone*/
		private var useClone:Boolean = false;
		
		/**
		 *设置 BitmapData 数据
		 * @param $bitmapData	BitmapData		$bitmapData不为空且外部监听了ClipEvent.FRAME_DATA_IS_READY事件则派发
		 * @param $useClone		是否使用BitmapData的clone
		 * @return 
		 */		
		public function setBitmapData($bitmapData:BitmapData, $useClone:Boolean = false):void
		{
			if(_bitmapData == $bitmapData || !$bitmapData) return;
			
			this.useClone = $useClone;
			_bitmapData = !useClone ? $bitmapData : $bitmapData.clone();
			
//			dispatchEvent(new ClipEvent(ClipEvent.FRAME_DATA_IS_READY, this));
		}
		
		private var _bitmapData:BitmapData;
		override public function set data(value:Object):void
		{
			if(this._bitmapData == value) return;
			this._bitmapData = value as BitmapData;
		}
		
		override public function get data():Object
		{
			return this._bitmapData;
		}

		
		override public function destroy():void
		{
			if(_bitmapData)
			{
				if(useClone)
				{
					_bitmapData.dispose();
				}
				
				_bitmapData = null;
			}
		}
	}
}