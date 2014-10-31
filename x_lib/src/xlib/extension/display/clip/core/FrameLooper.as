package xlib.extension.display.clip.core
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import xlib.extension.display.clip.insterfaces.IFrameLooper;
	import xlib.framework.core.Component;
	
	/**
	 *帧循环器（抽象类） <br>
	 * 子类调用execute执行循环，halt()停止
	 * @author yeah
	 */	
	public class FrameLooper extends Component implements IFrameLooper
	{
		public function FrameLooper()
		{
			super();
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
				_frameRate = stage.frameRate;
			}
			else
			{
				_frameRate = 0;
			}
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
		
		private var _repeatTimes:int = 0;
		public function get repeatTimes():int
		{
			return _repeatTimes;
		}
		
		/**
		 *设置当前循环次数 
		 * @param $repeatTimes -1则_repeatTimes+=1
		 */		
		private function setReaptTimes($repeatTimes:int = -1):void
		{
			_repeatTimes = $repeatTimes == -1 ? _repeatTimes + 1 : $repeatTimes;
			onRepeat();
			if(repeat != -1 && _repeatTimes >= repeat)
			{
				onEnd();
			}
		}
		
		private var _frameIndex:int = 0;
		public function get frameIndex():int
		{
			return _frameIndex;
		}

		public function set frameIndex(value:int):void
		{
			if(frameIndex == value) return;
			_frameIndex = value;
			onFrame();
		}
		
		protected var _totalFrames:int = 0;
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		private var _isRunning:Boolean = false;
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		
		public function destroy():void
		{
			halt();
			frameDuration = 0;
			_repeatTimes = 0;
			_totalFrames = 0;
			_frameIndex = 0;
			preTime = 0;
		}
		
		/**真正开始之前的时间*/
		private var preTime:int = 0;
		
		/**执行*/
		protected function execute():void
		{
			if(isRunning) return;
			_isRunning = true;
			if(!stage)
			{
				preTime = getTimer();					
				this.addEventListener(Event.ADDED_TO_STAGE, add2stage);
			}
			else
			{
				preTime = 0;	
				onReady();
			}
		}

		/***停止*/		
		protected function halt():void
		{
			if(!isRunning) return;
			_isRunning = false;
			onReady();
		}
		
		/**
		 *添加到舞台 
		 */		
		private function add2stage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, add2stage);
			
			if(frameRate == -1)
			{
				frameRate = stage.frameRate;
			}
			
			if(!isRunning) return;
			
			onReady();
		}
		
		/**
		 *准备完成
		 */		
		private function onReady():void
		{
			registerTimer(enterFrame);
		}
		
		/**
		 *注册计时器 
		 * @$executeFrames 在注册计时器之前应该执行的帧数
		 */		
		protected function registerTimer($enterFrame:Function):void
		{
			throw new IllegalOperationError("抽象方法必须重写");
		}
		
		/**
		 *解除注册计时器 
		 */		
		protected function unRegisterTimer($enterFrame:Function):void
		{
			throw new IllegalOperationError("抽象方法必须重写");
		}
		
		/**
		 * 每帧function
		 */		
		protected function enterFrame():void
		{
			var addFrame:int;
			if(preTime > 0)
			{
				preTime = getTimer() - preTime;
				addFrame = Math.round(preTime/frameDuration);
				preTime = 0;
			}
			else
			{
				addFrame = 1;
			}
			
			var tempFrame:int = frameIndex + addFrame;
			var flag:int = totalFrames-1;
			if(tempFrame < flag)
			{
				frameIndex = tempFrame;
			}
			else
			{
				frameIndex = tempFrame % flag;
				setReaptTimes(repeatTimes + tempFrame/flag);
			}
		}
		
		/**
		 *执行一帧 
		 */		
		protected function onFrame():void
		{
		}
		
		/**循环一次*/
		protected function onRepeat():void
		{
		}
		
		/**
		 *循环结束 
		 */		
		protected function onEnd():void
		{
		}
	}
}