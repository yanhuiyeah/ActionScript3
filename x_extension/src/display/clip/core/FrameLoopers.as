package display.clip.core
{
	import display.clip.insterfaces.IFrameLoopers;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import xlib.framework.core.Component;
	
	/**
	 *帧循环器 （抽象类）
	 * @author yeah
	 */	
	public class FrameLoopers extends Component implements IFrameLoopers
	{
		public function FrameLoopers()
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
		
		/**
		 *添加或移除舞台 
		 * @param $e
		 */		
		private function stageEventHandler($e:Event):void
		{
			checkPlayStatus();
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
		
		public function get isPlaying():Boolean
		{
			return playStatus > 1;
		}
		
		public function gotoAndPlay($frameIndex:int = 0):void
		{
			if(isPlaying) return;
			var tempReady:Boolean = isReady();
			_isReady = !tempReady;
			
			if(tempReady)
			{
				setPlayStatus(3);	
			}
			else
			{
				playStatus = 3;
				checkPlayStatus();
			}
		}
		
		public function gotoAndStop($frameIndex:int = -1):void
		{
			if(!isPlaying) return;
			setPlayStatus(0);
			checkPlayStatus();
		}
		
		public function pause():void
		{
			if(!isPlaying) return;
			setPlayStatus(0);
		}
		
		public function resume():void
		{
			if(playStatus != 1) return;
			setPlayStatus(3);
		}
		
		public function destory():void
		{
//			_loopFrames = 0;
//			frameDuration = 0;
//			_frameIndex = -1;
//			ctf = 0;
//			repeat = -1;
//			loopFrames = 0;
//			playStatus = 0;
		}
		
		/**
		 *下一帧的index索引 
		 */		
		private var nextFI:int;
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
			
			if(nextFI >= loopFrames-1)
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
			else
			{
				setFrameIndex(nextFI);
			}
			
			nextFI = ++nextFI % loopFrames;
		}
		
		/**真正开始之前的时间*/
		private var preTime:int = 0;
		
		/**
		 *播放状态, 0停止 1 暂停 2 后台播放（不渲染）3 正常播放
		 */		
		private var playStatus:uint = 0;
		
		/**
		 *设置播放状态 
		 * @param $value
		 */		
		private function setPlayStatus($value:uint):void
		{
			if(this.playStatus == $value) return;
			this.playStatus = $value;
			playStatus < 3?register(false):register(true);
		}
		
		/**
		 *检测播放状态 （isReady中条件值发生变化时必须调用）
		 */		
		final protected function checkPlayStatus():void
		{
			var flag:Boolean = isReady();
			if(flag == _isReady) return;
			_isReady = flag;
			
			if(isPlaying)
			{
				if(flag)
				{
					frameHandler();
					setPlayStatus(3);
				}
				else
				{
					setPlayStatus(2);
					preTime = getTimer();
				}
			}
			else if(flag)
			{
				frameHandler();
			}
		}
		
		private var _isReady:Boolean = false;
		/**
		 *播放准备条件 （子类可新增）
		 * @return 
		 */		
		protected function isReady():Boolean
		{
			return stage != null;
		}
		
		/**
		 *运行1帧
		 */		
		protected function onFrame():void
		{
			trace("onFrame", frameIndex, repeatTimes, repeat);
		}
		
		/**
		 *循环一次 
		 */		
		protected function onRepeat():void
		{
			trace("onRepeat", frameIndex, repeatTimes, repeat);
		}

		/**
		 *所有循环结束 
		 */		
		protected function onComplete():void
		{
			trace("onComplete", frameIndex, repeatTimes, repeat);
			gotoAndStop(this.frameIndex);
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
		 *注册timer 
		 * @param $frameHandler
		 */		
		protected function registerTimer($frameHandler:Function):void
		{
			throw new IllegalOperationError("抽象方法子类重写");
		}
		
		/**
		 *解除注册的timer 
		 * @param $frameHandler
		 */		
		protected function unRegisterTimer($frameHandler:Function):void
		{
			throw new IllegalOperationError("抽象方法子类重写");
		}
	}
}