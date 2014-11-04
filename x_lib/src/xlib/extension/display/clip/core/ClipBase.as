package xlib.extension.display.clip.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sampler.getSize;
	import flash.utils.getTimer;
	
	import xlib.extension.display.clip.data.FrameData;
	import xlib.extension.display.clip.insterfaces.IClip;
	import xlib.extension.display.clip.insterfaces.IClipData;
	import xlib.extension.display.clip.insterfaces.IFrameData;
	import xlib.framework.manager.TickManager;
	
	/**
	 *clip基类 
	 * @author yeah
	 */	
	public class ClipBase extends DataFrameLooper implements IClip
	{
		public function ClipBase($source:IClipData=null)
		{
			super($source);
		}
		
		public function get autoPlay():Boolean
		{
			return false;
		}
		
		public function set autoPlay($value:Boolean):void
		{
		}
		
		public function get autoRemoved():Boolean
		{
			return false;
		}
		
		public function set autoRemoved($value:Boolean):void
		{
		}
		
		public function get autoDestroy():Boolean
		{
			return false;
		}
		
		public function set autoDestroy($value:Boolean):void
		{
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
		
		public function play($frameIndex:int=-1, $frameLabel:String=null):void
		{
			if(!source)
			{
				throw new Error("还没有设置source");
			}
			execute();
		}
		
		public function stop($frameIndex:int=-1):void
		{
			halt();
		}
		
		public function pause():void
		{
		}
		
		override protected function onRender($frameData:IFrameData):void
		{
			var fd:FrameData = $frameData as FrameData;
			if(!fd) return;
			
			var p:Point = fd.offset;
			var posx:int;
			var posy:int;
			if(p)
			{
				posx = p.x;
				posy = p.y;
			}
			this.graphics.clear();
			this.graphics.beginBitmapFill(fd.data as BitmapData, getMatrix(p));
			this.graphics.drawRect(posx, posy, fd.data.width, fd.data.height);
			this.graphics.endFill();
		}
		
		private var matrix:Matrix;
		/**
		 *获取渲染matrix
		 * @param $offset
		 * @return 
		 */		
		private function getMatrix($offset:Point):Matrix
		{
			if($offset)
			{
				if(!matrix)
				{
					matrix = new Matrix();
				}
				matrix.identity();
				matrix.translate($offset.x, $offset.y);
				return matrix;
			}
			return null;
		}
		
		override protected function registerTimer($enterFrame:Function):void
		{
			TickManager.instance.doDuration($enterFrame, this.frameDuration);	
		}
		
		override protected function unRegisterTimer($enterFrame:Function):void
		{
			TickManager.instance.clean($enterFrame);
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
		
//		override protected function updateDisplayList($width:Number, $height:Number):void
//		{
//			super.updateDisplayList($width, $height);
//		}
	}
}