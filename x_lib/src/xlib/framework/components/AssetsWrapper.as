package xlib.framework.components
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import xlib.framework.components.interfaces.IBitmapDataRender;
	import xlib.framework.utils.GraphicsUtil;
	
	/**
	 *素材包装器具（不会主动渲染，请手动调用validateNow()进行渲染）
	 * @author yeah
	 */	
	public class AssetsWrapper extends Shape implements IBitmapDataRender
	{
		/**
		 * 构造函数
		 * @param $bitmapData	bitmapdata数据源
		 * @param $rect				缩放用的九宫格
		 */		
		public function AssetsWrapper($bitmapData:BitmapData = null, $rect:Rectangle = null)
		{
			super();
			this.bitmapData = $bitmapData;
			this.scale9Rect = $rect;
		}
		
		private var explicitWidth:Number = NaN;
		private var _width:Number = 0;
		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			if(explicitWidth == value) return;
			explicitWidth = value;
			if(_width == value) return;
			_width = value;
			invalidate();
		}
		
		private var explicitHeight:Number = NaN;
		private var _height:Number = 0;
		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			if(explicitHeight == value) return;
			explicitHeight = value;
			if(_height == value) return;
			_height = value;
			invalidate();
		}
		
		private var _useRepeat:Boolean = false;

		/**
		 *渲染模式--true : 重复， false:按照比例缩放<br> 
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
			measure();
			invalidate();
		}
		
		/**
		 *是否等待生效 
		 */		
		private var waitValidate:Boolean = false;
		
		/**
		 *属性失效 
		 */		
		public function invalidate():void
		{
			waitValidate = true;
		}
		
		/**
		 *属性生效
		 */		
		public function validateNow():void
		{
			if(!waitValidate) return;
			onRender();
		}
		
		/**
		 *开始渲染 
		 */		
		protected function onRender():void
		{
			this.graphics.clear();
			measure();
			if(!bitmapData) return;
			
			if(width < 1 || height < 1)
			{
				trace("尺寸不能小于1像素: width:", width, "height:", height);
				return;
			}
			
			var bmd:BitmapData;
			if(scale9Rect)			
			{
				bmd = (width == bitmapData.width && height == bitmapData.height) ? bitmapData : GraphicsUtil.scaledBitmapData(bitmapData, scale9Rect, width, height, null, matrix);
				matrix.identity();
			}
			else 
			{
				matrix.identity();
				if(!useRepeat)
				{
					matrix.a = width/bitmapData.width;
					matrix.d = height/bitmapData.height;
				}
				bmd = bitmapData;
			}
			this.graphics.beginBitmapFill(bmd, matrix, useRepeat, smooth);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		/**
		 *测量 
		 */		
		protected function measure():void
		{
			if(isNaN(explicitWidth))
			{
				_width = bitmapData ? bitmapData.width : 0;
			}
			else
			{
				_width = explicitWidth;
			}
			
			if(isNaN(explicitHeight))
			{
				_height = bitmapData ? bitmapData.height : 0;
			}
			else
			{
				_height = explicitHeight;
			}
		}
		
		/**
		 *矩阵 
		 */		
		private static var matrix:Matrix = new Matrix();
	}
}