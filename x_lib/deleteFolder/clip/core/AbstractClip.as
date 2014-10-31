package xlib.extension.display.clip.core
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import xlib.extension.display.clip.core.interfaceClass.IClip;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameData;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameDataList;
	import xlib.extension.display.clip.core.interfaceClass.IClipRenderer;
	import xlib.extension.display.clip.manager.ObjectPool;
	import xlib.framework.core.Component;
	
	use namespace clip_internal;
	
	/**
	 * IClip抽象类
	 * @author yeah
	 */	
	public class AbstractClip extends Component implements IClip
	{
		public function AbstractClip()
		{
			super();
		}
		
		/**播放继续*/
		private static const STATE_PLAY_CONTINUE:int = 2;
		
		/**播放挂起(记录播放起始信息，等待播放条件达成)*/
		private static const STATE_PLAY_SUSPEND:int = 1;
		
		/**初始化状态*/
		private static const STATE_INIT:int = 0;
		
		/**停止挂起(记录停止起始信息，等待停止条件达成)*/
		private static const STATE_STOP_SUSPEND:int = -1;
		
		/**真正停止*/
		private static const STATE_STOP_CONTINUE:int = -2;
		
		
		/**当前clip状态*/
		private var clipState:int = STATE_INIT;

		/**
		 *设置clip状态 
		 */		
		private function setClipState($value:int):void
		{
			if(clipState == $value) return;
			clipState = $value;
			if(clipState == STATE_INIT) return;
			
			switch(clipState)
			{
				case STATE_STOP_CONTINUE:
					continueStop();
					break;
				case STATE_PLAY_CONTINUE:
					continuePlay();
					break;
				case STATE_PLAY_SUSPEND:
					suspendPlay();
					break;
				case STATE_STOP_SUSPEND:
					break;
			}
		}
		
		public function get isPlaying():Boolean
		{
			return clipState > 0;
		}
		
		private var _autoPlay:Boolean = false;
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		
		public function set autoPlay($value:Boolean):void
		{
			if(this._autoPlay == $value) return;
			this._autoPlay = $value;
			
			if(clipState == STATE_INIT)
			{
				play(0);
			}
		}
		
		private var _autoDestroy:Boolean = false;
		public function get autoDestroy():Boolean
		{
			return _autoDestroy;
		}
		
		public function set autoDestroy($value:Boolean):void
		{
			if(_autoDestroy == $value) return;
			_autoDestroy = $value;
			if(autoDestroy)
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, true);
			}
			else
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			}
		}
		
		/**
		 *从显示列表移除 
		 * @param $e
		 */		
		private function removeFromStage($e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			if(autoDestroy)
			{
				destroy();
			}
		}		
		
		private var _frameRate:int = -1;
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		public function set frameRate($value:int):void
		{
			if(frameRate == $value || explicitDuration != -1) return;
			_frameRate = $value;
			_frameDuration = Math.floor(1000/frameRate);
		}
		
		/**
		 *外部显示设置的 frameDuration
		 */		
		private var explicitDuration:int = -1;
		private var _frameDuration:int = -1;
		public function get frameDuration():int
		{
			return _frameDuration;
		}
		
		public function set frameDuration($value:int):void
		{
			if(frameDuration == $value) return;
			explicitDuration = $value;
			if(explicitDuration != -1)
			{
				this._frameDuration = explicitDuration;
				this._frameRate = Math.ceil(1000/_frameDuration);
			}
			else
			{
				if(stage)
				{
					this._frameRate = stage.frameRate;
				}
				else if(this.frameRate < 0)
				{
					this._frameRate = 24;
				}
				this._frameDuration = Math.floor(1000/this.frameRate);
			}
			
			if(frameConnected)
			{
				cutFrame();
				connectFrame();
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
			this._repeat = $value;
			if(this.repeat != -1)
			{
				this._repeatCount = Math.min(this.repeatCount, repeat);
			}
			
			if(clipState == STATE_STOP_CONTINUE && this.repeatCount != repeat)
			{
				play(frameIndex);	
			}
		}
		
		private var _pivot:Point;
		public function get pivot():Point
		{
			return this._pivot;
		}
		
		public function set pivot($value:Point):void
		{
			if(!$value) 
			{
				$value = new Point();
			}
			
			if(!_pivot || _pivot.x != $value.x || _pivot.y != $value.y)
			{
				this._pivot = $value;
				
				if(clipRenderer)
				{
					clipRenderer.move(-this._pivot.x, -this._pivot.y);	
				}
			}
		}
		
		private var _clipRender:IClipRenderer;
		public function get clipRenderer():IClipRenderer
		{
			return this._clipRender;
		}
		
		public function set clipRenderer($value:IClipRenderer):void
		{
			if(this._clipRender == $value) return;
			var oldClip:IClipRenderer = this.clipRenderer;
			
			if(oldClip)
			{
				if(oldClip.self.parent)
				{
					oldClip.self.parent.removeChild(oldClip.self);
				}
				oldClip.destroy();
			}
			
			this._clipRender = $value;
			
			if(clipRenderer)
			{
				if(this.pivot)
				{
					clipRenderer.move(-this.pivot.x, -this.pivot.y);	
				}
				this.addChild(clipRenderer.self);
			}
			clipRenderChanged(oldClip);
		}
		
		private var _repeatCount:int = 0;
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		private var _source:IClipFrameDataList;
		public function get source():IClipFrameDataList
		{
			return _source;
		}
		
		public function set source($value:IClipFrameDataList):void
		{
			if(source == $value) return;
			var oldSource:IClipFrameDataList = this.source;
			this._source = $value;
			sourceChanged(oldSource);
			reset(this.autoPlay, this.autoDestroy, this.repeat, this.pivot, this.clipRenderer);
			_totalFrame = source?source.totalFrame:0;
			if(autoPlay && clipState == STATE_INIT)
			{
				play(0);
			}
			checkReadiness();
		}
		
		clip_internal var _totalFrame:int = 0;
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		private var _frameIndex:int = -1;
		public function get frameIndex():int
		{
			return _frameIndex;
		}
		
		/**
		 *更新 frameData 标志
		 */		
		private var updateFrameDataFlag:Boolean = false;
		
		private var _frameData:IClipFrameData;
		public function get frameData():IClipFrameData
		{
			if(updateFrameDataFlag)
			{
				_frameData = source.getFrameData(frameIndex);
				updateFrameDataFlag = false;
			}
			return _frameData;
		}
		
		public function play($frameIndex:int=-1):void
		{
			if(isPlaying) return;
			
			this.suspendFrame = Math.max(0, $frameIndex == -1 ? frameIndex : $frameIndex);
			this.suspendTimer = 0;
			this.clipState = STATE_PLAY_SUSPEND;
			clipReadiness = false;
			if(!checkReadiness())
			{
				this.suspendTimer = getTimer();			
				if(!stage)
				{
					this.addEventListener(Event.ADDED_TO_STAGE, add2Stage);
				}
			}
			else
			{
				setClipState(STATE_PLAY_CONTINUE);
			}
		}
		
		/**
		 *继续播放 
		 */		
		private function continuePlay():void
		{
			/**检测帧,如果没设置，置为stage的帧率*/
			if(frameDuration < 0)
			{
				frameRate = stage.frameRate;
			}
			
			/**检测clipRendere, 如果没设置，创建默认渲染器*/
			if(!clipRenderer)
			{
				clipRenderer = createDefaultClipRender();
			}
			
			/**计算挂起时经过的帧率和经过的循环数，并做出相应处理*/
			calculateSuspendFrame();
			
			/**如果循环没有结束 连接frame*/
			if(repeat != repeatCount)
			{
				connectFrame();
			}
		}
		
		/**
		 *挂起播放 
		 */		
		private function suspendPlay():void
		{
			this.suspendFrame = frameIndex;
			this.suspendTimer = getTimer();
			cutFrame();
		}
		
		public function stop($frameIndex:int=-1):void
		{
			if(!isPlaying) return;
			
			cutFrame();
			
			if($frameIndex == -1)
			{
				this.clipState = STATE_STOP_CONTINUE;
				return;
			}
			
			clipReadiness = false;
			this.suspendFrame = Math.max(0, $frameIndex == -1 ? frameIndex : $frameIndex);
			this.suspendTimer = 0;
			this.clipState = STATE_STOP_SUSPEND;
			
			if(!checkReadiness())
			{
				this.suspendTimer = getTimer();			
				if(!stage)
				{
					this.addEventListener(Event.ADDED_TO_STAGE, add2Stage);
				}
			}
		}
		
		/**
		 *停止 
		 */		
		private function continueStop():void
		{
			/**检测帧,如果没设置，置为stage的帧率*/
			if(frameDuration < 0)
			{
				frameRate = stage.frameRate;
			}
			
			/**检测clipRendere, 如果没设置，创建默认渲染器*/
			if(!clipRenderer)
			{
				clipRenderer = createDefaultClipRender();
			}
			
			setFrameIndex(suspendFrame);
			suspendFrame = 0;
		}
		
		public function pause():void
		{
			isPlaying ? stop(frameIndex) : play();
		}
		
		public function destroy():void
		{
			stop();
			
			if(clipRenderer)
			{
				clipRenderer.destroy();
				clipRenderer = null;
			}
			
			reset();
			
			if(source)
			{
				source.destroy();
				source = null;
			}
			
			ObjectPool.instance.push(this);
		}
		
		/**
		 *重置 
		 */		
		private function reset($autoPlay:Boolean = false, $autoDestroy:Boolean = false, $repeat:int = -1, 
							   $pivot:Point = null, $clipRender:IClipRenderer = null):void
		{
//			setClipState(STATE_INIT);
			this._repeatCount = 0;
			this._frameIndex = -1;
			this._frameData = null;
			this._autoPlay = $autoPlay;
			this._autoDestroy = $autoDestroy;
			this.pivot = $pivot;
			this.clipRenderer = $clipRender;
		}
		
		//==============================================
		/**
		 *计算挂起时经过的帧率和经过的循环数，并做出相应处理
		 * @param $frame
		 */		
		private function calculateSuspendFrame():void
		{
			/**检测挂起时经过的帧*/
			var passedFrame:int; 
			if(suspendTimer > 0)
			{
				suspendTimer = getTimer() - suspendTimer;
				passedFrame = Math.floor(suspendTimer/this.frameDuration);
				suspendTimer = 0;
			}
			if(passedFrame > 0)
			{
				suspendFrame += passedFrame;
			}
			
			/**计算经过的循环次数*/
			var maxFrameIndex:int = totalFrame - 1;
			var currentFrame:int = suspendFrame;
			suspendFrame = 0;
			if(currentFrame > maxFrameIndex)
			{
				this._repeatCount += currentFrame/ maxFrameIndex;
				currentFrame = suspendFrame % totalFrame;
			}
			
			setFrameIndex(currentFrame);
		}
		
		/**设置当前帧*/
		clip_internal function setFrameIndex($frame:int):void
		{
			if(this.frameIndex == $frame) return;
			var maxFrameIndex:int = totalFrame - 1;
			$frame = Math.min($frame, maxFrameIndex);
			
			this._frameIndex = $frame;
			updateFrameDataFlag = true;
			onFrame();
			invalidateRender();
			if(_frameIndex == maxFrameIndex)
			{
				this._repeatCount++;
				onRepeat();
				if(repeat != -1 && repeatCount >= repeat)
				{
					this._repeatCount = repeat;
					stop();
					onComplete();
				}
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(renderDirty)
			{
				commintRender();
				renderDirty = false;
			}
		}
		
		override protected function measured():void
		{
			if(clipRenderer)
			{
				measuredWidth = clipRenderer.width;
				measuredHeight = clipRenderer.height;
			}
			else
			{
				measuredWidth = 0;
				measuredHeight = 0;
			}
		}
		
		/**渲染标志*/
		private var renderDirty:Boolean = false;
		
		/**
		 *渲染延时
		 */		
		final protected function invalidateRender():void
		{
			if(renderDirty) return;
			renderDirty = true;
			invalidateProperties();
		}
		
		/**
		 *提交渲染 
		 */		
		protected function commintRender():void
		{
			if(!clipRenderer) return;
			clipRenderer.data = frameData;
			
			/**如果不是延时对象（此处暂时没有做判断），并且外部没有设置尺寸，此处做一下测量*/
			if(isNaN(explicitWidth) || isNaN(explicitHeight))
			{
				measured();
			}
		}
		/**
		 * frameIndex的顺延帧
		 * $reverse = true frameIndex的上一帧 
		 * $reverse = false frameIndex的下一帧 
		 */		
		protected function nextFrame($reverse:Boolean = false):void
		{
			var tempIndex:int = !$reverse ? frameIndex+1:frameIndex-1;
			var maxFrameIndex:int = totalFrame - 1;
			if(tempIndex < 0)
			{
				tempIndex = maxFrameIndex;
			}
			else if(tempIndex > maxFrameIndex)
			{
				tempIndex = 0;
			}
			setFrameIndex(tempIndex);
		}
		
		/**
		 *clipRender发生改变 
		 * @param $oldClip
		 */		
		protected function clipRenderChanged($oldClip:IClipRenderer):void
		{
			//处理旧的clipRender
			//处理新的clipRender
		}
		
		/**
		 *source 发生改变 
		 * @param $oldSource
		 */		
		protected function sourceChanged($oldSource:IClipFrameDataList):void
		{
			//处理旧的source
			//处理新的source
		}

		/**
		 *经过了一帧 
		 */		
		protected function onFrame():void
		{
		}

		/**
		 *经过了一个循环 
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
		
		//===================准备阶段=====================
		/**挂起状态时的getTimer()*/
		private var suspendTimer:int;
		/**挂起状态时的frameIndex*/
		private var suspendFrame:int;
		
		/**
		 *准备状态 
		 */		
		private var clipReadiness:Boolean = false;
		
		/**
		 *当前准备状态 比如：stage source 等等
		 */		
		protected function getClipReadiness():Boolean
		{
			return (stage && totalFrame > 0);
		}
		
		/**
		 *检测是否准备就绪，并进行相关操作
		 */		
		final protected function checkReadiness():Boolean
		{
			if(clipState == STATE_INIT) return false;
			var currentReadiness:Boolean = getClipReadiness();
			if(currentReadiness == clipReadiness) return clipReadiness;
			clipReadiness = currentReadiness;
			
			if(clipReadiness)
			{
				if(clipState == STATE_PLAY_SUSPEND)
				{
					setClipState(STATE_PLAY_CONTINUE);
				}
				else if(clipState == STATE_STOP_SUSPEND)
				{
					setClipState(STATE_STOP_CONTINUE);
				}
			}
			else if(clipState == STATE_PLAY_CONTINUE)
			{
				setClipState(STATE_PLAY_SUSPEND);
			}
			
			return clipReadiness;
		}
		
		/**
		 *添加到舞台 
		 * @param $e
		 */		
		private function add2Stage($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, add2Stage);
			checkReadiness();
		}
		
		//==================abstract=======================
		/**frame 是否处于连接状态*/
		private var frameConnected:Boolean = false;
		
		/**
		 *连接nextFrame() 
		 */		
		protected function connectFrame():Boolean
		{
			if(frameConnected) return false;
			frameConnected = true;
			return true;
		}
		
		/**
		 *切断nextFrame()连接 
		 */		
		protected function cutFrame():Boolean
		{
			if(!frameConnected) return false;
			frameConnected = false;
			return true;
		}
		
		/**
		 *创建clip默认渲染器(clipRenderer) 
		 * @return IClipRenderer
		 */		
		protected function createDefaultClipRender():IClipRenderer
		{
			throw new IllegalOperationError("createClipRender是抽象方法必须重写");
		}
		
		//=============================================
	}
}