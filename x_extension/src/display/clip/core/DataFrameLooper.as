package display.clip.core
{
	import display.clip.insterfaces.IClipData;
	import display.clip.insterfaces.IDataFrameLooper;
	import display.clip.insterfaces.IFrameData;
	
	import flash.errors.IllegalOperationError;
	
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
		
		private var sourceChanged:Boolean = false;
		private var _source:IClipData;
		public function get source():IClipData
		{
			return _source;
		}
		
		public function set source($value:IClipData):void
		{
			if(_source == $value) return;
			sourceChanged = true;
			_source = $value;
			invalidateProperties();
		}
		
		private var frameLabelChanged:Boolean = false;
		private var _frameLabel:String = null;
		public function get frameLabel():String
		{
			return _frameLabel;
		}
		
		public function set frameLabel($value:String):void
		{
			if(this._frameLabel == $value) return;
			frameLabelChanged = true;
			this._frameLabel = $value;
			invalidateProperties();
		}
		
		private var _frameData:IFrameData;
		public function get frameData():IFrameData
		{
			return _frameData;
		}
		
		/**
		 *设置framedata 
		 * @param $value
		 */		
		private function setFrameData($value:IFrameData):void
		{
			if(_frameData == $value) return;
			_frameData = $value;
			onRender(_frameData);
		}
		
		private var dataChanged:Boolean = false;
		override protected function onFrame():void
		{
			dataChanged = true;
			invalidateProperties();
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
			
			if(sourceChanged)
			{
				if(!frameLabelChanged && source && source.frameLabels.length > 0)
				{
					frameLabel = source.frameLabels[0];
				}
				else
				{
					loopFrames = 0;
				}
				sourceChanged = false;
			}
			
			if(frameLabelChanged)
			{
				loopFrames = source.getFrameCount(frameLabel);
				frameLabelChanged = false;
			}
			
			if(dataChanged)
			{
				var currentData:IFrameData = source.getFrame(frameIndex, frameLabel);
				var needMeasure:Boolean = currentData != frameData;
				setFrameData(currentData);
				if(needMeasure)
				{
					invalidateSize();
				}
				dataChanged = false;
			}
		}
	}
}