package xlib.framework.components
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import xlib.framework.xlib_internal;
	import xlib.framework.core.Component;
	
	use namespace xlib_internal;
	
	/**
	 *素材包装器 
	 * @author yeah
	 */	
	public class Wapper extends Component
	{
		public function Wapper($bitmapData:BitmapData = null, $rect:Rectangle = null)
		{
			super();
		}
		
		private var _useRepeat:Boolean = true;
		
		/**
		 *渲染模式是按照比例缩放还是重复，默认：true<br> 
		 * 如果设置了scale9Rect此参数无效
		 * @return 
		 */		
		public function get useRepeat():Boolean
		{
			return _useRepeat;
		}
		
		public function set useRepeat(value:Boolean):void
		{
			if(_useRepeat == value) return;	
			_useRepeat = value;
			invalidate();
		}
		
		private var _smooth:Boolean = false;
		
		/**
		 * (default = false) — <br>
		 * 如果为 false，则使用最近邻点算法来呈现放大的位图图像，而且该图像看起来是像素化的。<br>
		 * 如果为 true，则使用双线性算法来呈现放大的位图图像。使用最近邻点算法呈现较快。  <br>
		 */
		public function get smooth():Boolean
		{
			return _smooth;
		}
		
		/**
		 * @private
		 */
		public function set smooth(value:Boolean):void
		{
			if(_smooth == value) return;
			_smooth = value;
			invalidate();
		}
		
		private var _scale9Rect:Rectangle;
		/**
		 *九宫格 
		 */
		public function get scale9Rect():Rectangle
		{
			return _scale9Rect;
		}
		
		/**
		 * @private
		 */
		public function set scale9Rect(value:Rectangle):void
		{
			if(_scale9Rect == value) return;
			_scale9Rect = value;
			invalidate();
		}
		
		private var _bitmapData:BitmapData;
		/**
		 * BitmapData
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		/**
		 * @private
		 */
		public function set bitmapData(value:BitmapData):void
		{
			if(_bitmapData == value) return;
			_bitmapData = value;
			invalidate();
		}
		
		/**
		 *渲染
		 */		
		protected function renderWapper($width:Number, $height:Number):void
		{
			this.graphics.clear();
			if(!bitmapData) return;
			
			var bmd:BitmapData;
			if(scale9Rect)			
			{
				bmd = ($width == bitmapData.width && bitmapData.height == $height) ? bitmapData : getScaledBitmapData(bitmapData, scale9Rect, $width, $height);
				matrix.identity();
			}
			else 
			{
				matrix.identity();
				if(!useRepeat)
				{
					matrix.a = $width/bitmapData.width;
					matrix.d = $height/bitmapData.height;
				}
				bmd = bitmapData;
			}
			this.graphics.beginBitmapFill(bmd, matrix, useRepeat, smooth);
			this.graphics.drawRect(0, 0, $width, $height);
			this.graphics.endFill();
		}
		
		override protected function measure():void
		{
			if(bitmapData)
			{
				measuredWidth = bitmapData.width;
				measuredHeight = bitmapData.height;
			}
			else
			{
				measuredWidth = 0;
				measuredHeight = 0;
			}
		}
		
		override protected function updateDisplayList($width:Number, $height:Number):void
		{
			super.updateDisplayList($width, $height);
			if(waitValidate)
			{
				renderWapper($width, $height);
			}
		}
		
		/**
		 *是否等待生效 
		 */		
		private var waitValidate:Boolean = false;
		
		/**
		 *延时 
		 */		
		private function invalidate():void
		{
			if(waitValidate) return;
			waitValidate = true;
			invalidateProperties();
		}
		
		/**
		 *矩阵 
		 */		
		private static var matrix:Matrix = new Matrix();
		
		/**
		 *返回根据九宫格缩放后的bitmapdata 
		 * @param $bmd
		 * @param $s9r
		 * @param $unscaledWidth
		 * @param $unscaledHeight
		 * @return 一个bitmapdata副本
		 */		
		public static function getScaledBitmapData($bmd:BitmapData, $s9r:Rectangle, $unscaledWidth:Number, $unscaledHeight:Number):BitmapData
		{
			/**应该缩放的宽高*/
			var scaledW:Number = $unscaledWidth - $bmd.width + $s9r.width;
			var scaledH:Number = $unscaledHeight - $bmd.height + $s9r.height;
			
			/**未进行缩放的水平/竖直的点*/
			var hValues:Array = [$s9r.x, $s9r.width, $bmd.width - $s9r.right];
			var vValues:Array = [$s9r.y, $s9r.height, $bmd.height - $s9r.bottom];
			
			matrix.identity();
			var bmd:BitmapData = new BitmapData($unscaledWidth, $unscaledHeight);
			
			var unScaledRect:Rectangle = new Rectangle();	//未缩放的rect
			var scaledRect:Rectangle = new Rectangle();			//缩放后的rect
			
			var hScaled:Boolean = true;									//是否需要缩放  false true false
			var vScaled:Boolean = true;									//是否需要缩放  false true false
			for each (var x_value:int in hValues) 
			{
				hScaled = !hScaled;
				
				unScaledRect.y = 0;
				unScaledRect.width = x_value;
				
				scaledRect.y = 0;
				scaledRect.width = !hScaled ? x_value : scaledW;
				
				matrix.a = scaledRect.width / unScaledRect.width;
				matrix.tx = scaledRect.x - matrix.a* unScaledRect.x;
				
				vScaled = true;
				for each (var v_value:int in vValues) 
				{
					vScaled = !vScaled;
					unScaledRect.height  = v_value;
					scaledRect.height  = !vScaled ? v_value : scaledH;
					
					matrix.d = scaledRect.height / unScaledRect.height;
					matrix.ty = scaledRect.y - matrix.d * unScaledRect.y;
					
					bmd.draw($bmd, matrix, null, null, scaledRect);
					
					unScaledRect.y = unScaledRect.bottom;	
					scaledRect.y = scaledRect.bottom;	
				}
				
				unScaledRect.x = unScaledRect.right;
				scaledRect.x = scaledRect.right;
			}
			return bmd;
		}
	}
}