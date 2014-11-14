package display.clip.core
{
	import display.clip.events.ClipEvent;
	import display.clip.insterfaces.IFrameLooper;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import xlib.framework.core.Component;
	
	/**
	 *帧循环器 显示对象
	 * @author yeah
	 */	
	public class ClipLooper extends Component implements IFrameLooper
	{
		public function ClipLooper()
		{
			super();
			looperInit();
		}
		
		/**
		 *循环器初始化 
		 */		
		private function looperInit():void
		{
			looper = createLooper();
			looper.dispatcher = this;
			this.mouseEnabled = this.mouseChildren = false;
			checkStageEvent();
		}
		
		/**
		 *循环器 
		 */		
		protected var looper:FrameLooper;
		
		/**
		 *创建循环器 
		 * @return 
		 */		
		protected function createLooper():FrameLooper
		{
			return new FrameLooper();
		}
		
		/**
		 *监听舞台 
		 */		
		private function checkStageEvent():void
		{
			if(autoSuspend)
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
			checkSuspend();
		}
		
		public function get autoSuspend():Boolean
		{
			return looper.autoSuspend;
		}

		public function set autoSuspend(value:Boolean):void
		{
			if(looper.autoSuspend == value) return;
			looper.autoSuspend = value;
			checkSuspend();
		}
		
		public function get loopFrames():int
		{
			return looper.loopFrames;
		}
		
		public function set loopFrames($value:int):void
		{
			looper.loopFrames = $value;
		}
		
		public function get repeat():int
		{
			return looper.repeat;
		}
		
		public function set repeat($value:int):void
		{
			looper.repeat = $value;
		}
		
		public function get repeatTimes():int
		{
			return looper.repeatTimes;
		}
		
		public function get frameRate():uint
		{
			return looper.frameRate;
		}
		
		public function set frameRate($value:uint):void
		{
			looper.frameRate = $value;
		}
		
		public function get frameDuration():uint
		{
			return looper.frameDuration;
		}
		
		public function set frameDuration($value:uint):void
		{
			looper.frameDuration = $value;
			if(looper.frameDuration < 1 && stage)
			{
				frameRate = stage.frameRate;
			}
		}
		
		public function get frameIndex():int
		{
			return looper.frameIndex;
		}
		
		public function get isPlaying():Boolean
		{
			return looper.isPlaying;
		}
		
		public function gotoAndPlay($frameIndex:int = 0):void
		{
			checkSuspend();
			looper.gotoAndPlay($frameIndex);
		}
		
		public function gotoAndStop($frameIndex:int = -1):void
		{
			looper.gotoAndStop($frameIndex);
		}
		
		public function pause():void
		{
			looper.pause();
		}
		
		public function resume():void
		{
			looper.resume();
		}
		
		public function destroy():void
		{
			looper.destroy();
		}
		
		/**
		 *检测挂起状态 
		 */		
		final protected function checkSuspend():void
		{
			looper.setSuspend(getSuspended());
		}
		
		public function get suspended():Boolean
		{
			return looper.suspended;
		}
		
		/**
		 *挂起条件 
		 * @return 
		 */		
		protected function getSuspended():Boolean
		{
			return !hasStage;
		}
	}
}