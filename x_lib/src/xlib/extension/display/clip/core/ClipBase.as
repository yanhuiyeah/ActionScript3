package xlib.extension.display.clip.core
{
	import flash.geom.Point;
	
	import xlib.extension.display.clip.insterfaces.IClip;
	import xlib.extension.display.clip.insterfaces.IClipData;
	import xlib.extension.display.clip.insterfaces.IFrameData;
	
	/**
	 *clip基类(抽象类)<br>
	 * 需重写onRender方法，渲染IFramedata<br>
	 * 需重写registerTimer注册计时器
	 * 需重写unRegisterTimer解除注册的计时器
	 * @author yeah
	 */	
	public class ClipBase extends DataFrameLooper implements IClip
	{
		public function ClipBase($source:IClipData=null)
		{
			super($source);
		}
		
		private var _autoPlay:Boolean = false;
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		
		public function set autoPlay($value:Boolean):void
		{
			_autoPlay = true;
		}
		
		private var _autoRemoved:Boolean = false;
		public function get autoRemoved():Boolean
		{
			return _autoRemoved;
		}
		
		public function set autoRemoved($value:Boolean):void
		{
			this._autoRemoved = $value;
		}
		
		private var _autoDestroy:Boolean = false;
		public function get autoDestroy():Boolean
		{
			return _autoDestroy;
		}
		
		public function set autoDestroy($value:Boolean):void
		{
			this._autoDestroy = $value;
		}
		
		private var _pivot:Point;
		public function get pivot():Point
		{
			return _pivot;
		}
		
		public function set pivot($value:Point):void
		{
			if(_pivot == $value) return;
			_pivot = $value;
			x = x;
			y = y;
		}
		
		override public function set source($value:IClipData):void
		{
			super.source = $value;
			if(source && autoPlay && !isRunning)
			{
				play();
			}
		}
		
		public function play($frameLabel:String=null):void
		{
			if(!source)
			{
				throw new Error("还没有设置source");
			}
			
			if($frameLabel)
			{
				this.frameLabel = $frameLabel;
			}
			execute();
		}
		
		public function stop():void
		{
			halt();
			if(autoRemoved)
			{
				removeSelf();
			}
		}
		
		public function pause():void
		{
			if(!isRunning) return;
			unRegisterTimer(enterFrame);
		}
		
		public function resume():void
		{
			if(!isRunning) return;
			registerTimer(enterFrame);
		}
		
		/**
		 *移除自己 
		 */		
		private function removeSelf():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
			
			if(autoDestroy)
			{
				destroy();
			}
		}
		
		private var explicitX:Number = NaN;
		override public function set x(value:Number):void
		{
			if(explicitX == value && !isNaN(explicitX)) return;
			explicitX = value;
			if(pivot)
			{
				value -= pivot.x;
			}
			super.x = value;
		}
		
		override public function get x():Number
		{
			return isNaN(explicitX)? 0 : explicitX;
		}
		
		private var explicitY:Number = NaN;
		override public function set y(value:Number):void
		{
			if(explicitY == value && !isNaN(explicitY)) return;
			explicitY = value;
			if(pivot)
			{
				value -= pivot.y;
			}
			super.y = value;
		}
		
		override public function get y():Number
		{
			return isNaN(explicitY)? 0 : explicitY;
		}
		
		override protected function isNotHang():Boolean
		{
			return super.isNotHang() && visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			if(super.visible == value) return;
			super.visible = value;
			checkHang();
		}
	}
}