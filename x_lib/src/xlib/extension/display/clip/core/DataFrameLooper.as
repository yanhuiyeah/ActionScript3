package xlib.extension.display.clip.core
{
	import flash.errors.IllegalOperationError;
	
	import xlib.extension.display.clip.insterfaces.IClipData;
	import xlib.extension.display.clip.insterfaces.IDataFrameLooper;
	import xlib.extension.display.clip.insterfaces.IFrameData;
	
	/**
	 *带有数据源的帧循环器 
	 * @author yeah
	 */	
	public class DataFrameLooper extends FrameLooper implements IDataFrameLooper
	{
		public function DataFrameLooper($source:IClipData = null)
		{
			super();
			if($source)
			{
				this.source = $source;
			}
		}
		
		private var _source:IClipData;
		public function get source():IClipData
		{
			return _source;
		}
		
		public function set source($value:IClipData):void
		{
			if(_source == $value) return;
			if(_source)
			{
			}
			_source = $value;
			if(_source)
			{
				if(source.frameLabels.length > 0)
				{
					frameLabel = source.frameLabels[0];
					_totalFrames = source.getFrameCount(frameLabel);
				}
			}
			dataChanged = true;
			invalidateProperties();
		}
		
		private var _frameLabel:String = null;
		public function get frameLabel():String
		{
			return _frameLabel;
		}
		
		public function set frameLabel($value:String):void
		{
			if(this._frameLabel == $value) return;
			this._frameLabel = $value;
			
			if(source && source.frameLabels.length > 0)
			{
				if(!source.hasFrameLabel(frameLabel))
				{
					_frameLabel = source.frameLabels[0];
				}
				_totalFrames = source.getFrameCount(frameLabel);
				frameIndex = 0;
			}
			dataChanged = true;
			invalidateProperties();
		}
		
		private var _frameData:IFrameData;
		public function get frameData():IFrameData
		{
			return _frameData;
		}
		
		private var dataChanged:Boolean = false;
		override protected function onFrame():void
		{
			dataChanged = true;
			invalidateProperties();
		}
		
		/**
		 *设置framedata 
		 * @param $value
		 */		
		private function setFrameData($value:IFrameData):Boolean
		{
			if(_frameData == $value) return false;
			_frameData = $value;
			onRender(_frameData);
			return true;
		}
		
		override public function destroy():void
		{
			super.destroy();
			this.source = null;
			this._frameLabel = null;
			_frameData = null;
		}

		/**
		 *渲染（子类可重写渲染方式）
		 */		
		protected function onRender($frameData:IFrameData):void
		{
			throw new IllegalOperationError("抽象方法必须被重写");
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(dataChanged)
			{
				var tempData:IFrameData;
				if(frameLabel && source)
				{
					tempData = source.getFrame(frameIndex, frameLabel);
				}
				
				if(setFrameData(tempData))
				{
					invalidateSize();
				}
				dataChanged = false;
			}
		}
	}
}