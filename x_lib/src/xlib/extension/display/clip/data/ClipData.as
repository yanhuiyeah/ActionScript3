package xlib.extension.display.clip.data
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import xlib.extension.display.clip.insterfaces.IClipData;
	import xlib.extension.display.clip.insterfaces.IFrameData;
	import xlib.framework.core.LazyDispatcher;
	
	/**
	 *clip数据源 
	 * @author yeah
	 */	
	public class ClipData extends LazyDispatcher implements IClipData
	{
		/**
		 *默认标签 
		 */		
		public static const MAIN:String = "main";
		
		
		/**
		 * 缓存的数据
		 */		
		private var cacheData:Dictionary;
		
		public function ClipData($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
			cacheData = new Dictionary();
			_frameLabels = new Vector.<String>();
		}
		
		private var _totalFrame:int;
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		private var _frameLabels:Vector.<String>;

		public function get frameLabels():Vector.<String>
		{
			return _frameLabels;
		}
		
		public function getFrameCount($frameLabel:String="main"):int
		{
			var vector:Vector.<IFrameData> = getFrames($frameLabel);
			if(vector)
			{
				return vector.length;
			}
			return 0;
		}
		
		public function addFrames($frames:Vector.<IFrameData>, $frameLabel:String="main"):void
		{
			if(!$frameLabel)
			{
				throw new Error("帧标签不能为空！");
			}
			var vector:Vector.<IFrameData> = getFrames($frameLabel);
			if(!vector)
			{
				cacheData[$frameLabel] = $frames;
				_frameLabels.push($frameLabel);
			}
			else
			{
				vector = vector.concat($frames);
			}
			
			_totalFrame += $frames.length;
		}
		
		public function removeFrames($frameLabel:String="main"):Vector.<IFrameData>
		{
			var vector:Vector.<IFrameData>;
			if(!$frameLabel)
			{
				var len:int = frameLabels.length;
				while(len > 0)
				{
					var key:String = frameLabels.pop();
					if(!vector)
					{
						vector = new Vector.<IFrameData>();
					}
					vector = vector.concat(cacheData[key]);
					delete cacheData[key];
					len--;
				}
				_totalFrame = 0;
			}
			else if(hasFrameLabel($frameLabel))
			{
				vector = cacheData[$frameLabel];
				delete cacheData[$frameLabel];
				_totalFrame -= vector.length;
				var index:int = frameLabels.indexOf($frameLabel);
				frameLabels.splice(index, 1);
			}
			return vector;
		}
		
		public function getFrames($frameLabel:String = "main"):Vector.<IFrameData>
		{
			var vector:Vector.<IFrameData>;
			if(hasFrameLabel($frameLabel))
			{
				vector = cacheData[$frameLabel];
			}
			return vector;
		}
		
		public function getFrame($index:int, $frameLabel:String="main"):IFrameData
		{
			var vector:Vector.<IFrameData> = getFrames($frameLabel);
			if(vector && $index < vector.length)
			{
				return vector[$index];
			}
			return null;
		}
		
		public function hasFrameLabel($frameLabel:String):Boolean
		{
			return frameLabels && frameLabels.indexOf($frameLabel) != -1;
		}
		
		public function hasFrame($frameData:IFrameData, $frameLabel:String="main"):Boolean
		{
			var vector:Vector.<IFrameData> = getFrames($frameLabel);
			if(!vector) return false;
			return vector.indexOf($frameData) != -1;
		}
		
		public function refresh():void
		{
		}
		
		public function destroy():void
		{
			_totalFrame = 0;
			_frameLabels.length = 0;
			cacheData = new Dictionary();
		}
	}
}