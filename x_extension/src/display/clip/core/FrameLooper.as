package display.clip.core
{
	import display.clip.events.ClipEvent;
	import display.clip.insterfaces.IFrameLooper;
	
	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import xlib.framework.core.LazyDispatcher;
	import xlib.framework.manager.TickManager;
	
	/**播放结束*/
	[Event(name="complete", type="display.clip.events.ClipEvent")]
	/**一个循环*/
	[Event(name="repeat", type="display.clip.events.ClipEvent")]
	/**每帧*/
	[Event(name="frame", type="display.clip.events.ClipEvent")]
	
	public class FrameLooper extends LazyDispatcher implements IFrameLooper
	{
		public function FrameLooper($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		private var _autoSuspend:Boolean = true;
		public function get autoSuspend():Boolean
		{
			return _autoSuspend;
		}
		
		public function set autoSuspend(value:Boolean):void
		{
			_autoSuspend = value;
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
				this.dispatchEvent(new ClipEvent(ClipEvent.REPEAT));
				if(_repeatTimes == repeat)
				{
					gotoAndStop(this.frameIndex);
					this.dispatchEvent(new ClipEvent(ClipEvent.COMPLETE));
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
				setSuspend(moreSuspend);
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
			this.dispatchEvent(new ClipEvent(ClipEvent.FRAME));
		}
		
		private var _isPlaying:Boolean = false;
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function gotoAndPlay($frameIndex:int = 0):void
		{
			isPause = false;
			nextFI = $frameIndex;
			if(isPlaying) return;
			
			setSuspended();
			if(!suspended)
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
		
		private var isPause:Boolean = false;
		public function pause():void
		{
			if(isPause) return;
			isPause = true;
			gotoAndStop(this.frameIndex);
		}
		
		public function resume():void
		{
			if(!isPause) return;
			isPause = false;
			gotoAndPlay(this.frameIndex);
		}
		
		override public function destroy():void
		{
			gotoAndStop();
			_loopFrames = 0;
			frameDuration = 0;
			_frameIndex = -1;
			nextFI = 0;
			repeat = -1;
			_repeatTimes = 0;
			loopFrames = 0;
			moreSuspend = false;
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
			
			if(loopFrames < 1)
			{
				setFrameIndex(nextFI);
				nextFI++;
			}
			else
			{
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
		}
		
		/**真正开始之前的时间*/
		private var preTime:int = 0;
		
		/**
		 *播放但是不执行帧 
		 */		
		final protected function playWithoutFrame():void
		{
			_isPlaying = true;
			preTime = getTimer();
			register(false);
		}
		
		private var _suspended:Boolean;
		/**
		 *是否处于挂起状态 true 挂起 false 正常
		 */
		public function get suspended():Boolean
		{
			return _suspended;
		}
		
		/**
		 *设置挂起状态 
		 * @return 
		 */		
		private function setSuspended():Boolean
		{
			_suspended = moreSuspend || frameDuration < 1;
			return suspended;
		}

		/**
		 *其他挂起条件 
		 */		
		private var moreSuspend:Boolean = false;
		
		/**
		 *检测挂起状态 
		 * @param $value	其它挂起条件
		 */		
		final public function setSuspend($value:Boolean):void
		{
			var oldSuspended:Boolean = suspended;
			moreSuspend = $value;
			setSuspended();
			if(!isPlaying || oldSuspended == suspended) return;
			if(!suspended)
			{
				register(true);
			}
			else
			{
				playWithoutFrame();
			}
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
			TickManager.instance.doDuration($frameHandler, this.frameDuration);
		}
		
		/**
		 *解除registerTimer注册的timer 
		 * @param $frameHandler
		 */		
		protected function unRegisterTimer($frameHandler:Function):void
		{
			TickManager.instance.clean($frameHandler);
		}
	}
}