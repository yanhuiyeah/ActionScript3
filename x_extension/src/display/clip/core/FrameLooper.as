package display.clip.core
{
	import display.clip.insterfaces.IFrameLooper;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import xlib.framework.core.Component;
	
	/**
	 *帧循环器 （抽象类）
	 * @author yeah
	 */	
	public class FrameLooper extends Component implements IFrameLooper
	{
		public function FrameLooper()
		{
			super();
			this.mouseEnabled = this.mouseChildren = false;
			checkStageEvent();
		}
		
		/**
		 *监听舞台 
		 */		
		private function checkStageEvent():void
		{
			if(autoHang)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, stageEventHandler);
				this.addEventListener(Event.REMOVED_FROM_STAGE, stageEventHandler);
			}
			else
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, stageEventHandler);
				this.removeEventListener(Event.REMOVED_FROM_STAGE, stageEventHandler);
			}
		}
		
		private var hasStage:Boolean = false;
		/**
		 *添加或移除舞台 
		 * @param $e
		 */		
		private function stageEventHandler($e:Event):void
		{
			hasStage = $e.type == Event.ADDED_TO_STAGE;
			checkPlayState();
		}
		
		private var _autoHang:Boolean = true;
		public function get autoHang():Boolean
		{
			return _autoHang;
		}

		public function set autoHang(value:Boolean):void
		{
			if(_autoHang == value) return;
			_autoHang = value;
			checkStageEvent();
		}
		
		private var _loopFrames:int;
		public function get loopFrames():int
		{
			return _loopFrames;
		}
		
		public function set loopFrames($value:int):void
		{
			if(_loopFrames == $value) return;
			_loopFrames = $value;
		}
		
		private var _repeat:int = -1;
		public function get repeat():int
		{
			return _repeat;
		}
		
		public function set repeat($value:int):void
		{
			if(_repeat == $value) return;
			_repeat = $value;
		}
		
		private var _repeatTimes:int;
		public function get repeatTimes():int
		{
			return _repeatTimes;
		}
		
		private function setRepeatTimes($value:int):void
		{
			if(_repeatTimes == $value) return;
			_repeatTimes = $value;
			if(loopFrames > 0 && frameIndex == loopFrames-1)
			{
				onRepeat();
				if(_repeatTimes == repeat)
				{
					gotoAndStop(this.frameIndex);
					onComplete();
				}
			}
		}
		
		private var _frameRate:uint = 0;
		public function get frameRate():uint
		{
			return _frameRate;
		}
		
		public function set frameRate($value:uint):void
		{
			if(_frameRate == $value || explicitFrameDuration > 0) return;
			_frameRate = $value;
			_frameDuration = Math.floor(1000/_frameRate);
		}
		
		/**外部显示设置的帧间隔时间*/
		private var explicitFrameDuration:uint = 0;
		private var _frameDuration:uint = 0;
		public function get frameDuration():uint
		{
			return _frameDuration;
		}
		
		public function set frameDuration($value:uint):void
		{
			if(explicitFrameDuration == $value) return;
			explicitFrameDuration = $value;
			if(frameDuration == $value) return;
			_frameDuration = $value;
			if(_frameDuration > 0)
			{
				_frameRate = Math.ceil(1000/_frameDuration);
			}
			else if(stage)
			{
				frameRate = stage.frameRate;
			}
			else
			{
				_frameRate = 0;
			}
		}
		
		private var _frameIndex:int = -1;
		public function get frameIndex():int
		{
			return _frameIndex;
		}
		
		private function setFrameIndex($value:int):void
		{
			if(_frameIndex == $value) return;
			_frameIndex = $value;
			onFrame();
		}
		
		private var _isPlaying:Boolean = false;
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function gotoAndPlay($frameIndex:int = 0):void
		{
			nextFI = $frameIndex;
			if(isPlaying) return;
			var ready:Boolean = isReady();
			if(ready)
			{
				_isPlaying = true;
				register(true);
			}
			else
			{
				playWithoutFrame();
			}
		}
		
		public function gotoAndStop($frameIndex:int = -1):void
		{
			if(!isPlaying) return;
			_isPlaying = false;
			register(false);
			if(loopFrames > 0)
			{
				nextFI = $frameIndex > -1 ? $frameIndex:frameIndex;
			}
			frameHandler();
		}
		
		public function pause():void
		{
			gotoAndStop(this.frameIndex);
		}
		
		public function resume():void
		{
			gotoAndPlay(this.frameIndex);
		}
		
		public function destroy():void
		{
			gotoAndStop();
			_loopFrames = 0;
			frameDuration = 0;
			_frameIndex = -1;
			nextFI = 0;
			repeat = -1;
			_repeatTimes = 0;
			loopFrames = 0;
		}
		
		/**
		 *下一帧的index索引 
		 */		
		protected var nextFI:int;
		/**
		 *每帧运行 
		 */		
		private function frameHandler():void
		{
			if(preTime > 0)
			{
				preTime = getTimer() - preTime;
				if(preTime > frameDuration)
				{
					nextFI += Math.round(preTime/frameDuration);
				}
				preTime = 0;
			}
			
			if(nextFI < loopFrames-1)
			{
				setFrameIndex(nextFI);
			}
			else
			{
				var currentRT:int = nextFI / (loopFrames -1) + _repeatTimes;
				if(repeat != -1 && currentRT >= repeat)
				{
					nextFI = loopFrames -1;
					currentRT = repeat;
				}
				else
				{
					nextFI %= loopFrames;
				}
				setFrameIndex(nextFI);
				setRepeatTimes(currentRT);
			}
			
			nextFI = ++nextFI % loopFrames;
		}
		
		/**真正开始之前的时间*/
		private var preTime:int = 0;
		
		private var _isReady:Boolean = false;
		/**
		 *播放但是不执行帧 
		 */		
		final protected function playWithoutFrame():void
		{
			_isPlaying = true;
			preTime = getTimer();
			register(false);
		}
		
		final protected function checkPlayState():void
		{
			var ready:Boolean = isReady();
			if(_isReady == ready) return;
			_isReady = ready;
			if(!isPlaying) return;
			if(_isReady)
			{
				register(true);
			}
			else
			{
				playWithoutFrame();
			}
		}
		
		/**
		 *播放准备条件 （子类可新增）
		 * @return 
		 */		
		protected function isReady():Boolean
		{
			if(!autoHang)
			{
				return frameDuration > 0;
			}
			return hasStage;
		}
		
		/**
		 *运行1帧
		 */		
		protected function onFrame():void
		{
		}
		
		/**
		 *循环一次 
		 */		
		protected function onRepeat():void
		{
		}

		/**
		 *所有循环结束 
		 */		
		protected function onComplete():void
		{
		}
		
		private var isRegister:Boolean = false;
		/**
		 *注册 
		 * @param $value
		 */		
		private function register($value:Boolean):void
		{
			if(isRegister == $value) return;
			isRegister = $value;
			if(isRegister)
			{
				registerTimer(this.frameHandler);
			}
			else
			{
				unRegisterTimer(this.frameHandler);
			}
		}
		
		/**
		 *注册timer （注册后要求每隔frameduration执行一次$frameHandler）
		 * @param $frameHandler
		 */		
		protected function registerTimer($frameHandler:Function):void
		{
			throw new IllegalOperationError("抽象方法子类重写");
		}
		
		/**
		 *解除registerTimer注册的timer 
		 * @param $frameHandler
		 */		
		protected function unRegisterTimer($frameHandler:Function):void
		{
			throw new IllegalOperationError("抽象方法子类重写");
		}
	}
}