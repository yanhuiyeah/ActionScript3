package xlib.framework.components
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import xlib.framework.core.Global;
	import xlib.framework.events.TickEvent;
	import xlib.framework.events.UIEvent;
	
	/**
	 *更新完成的事件 
	 */	
	[Event(name="updateComplete", type="xlib.framework.events.UIEvent")]
	
	/**
	 *图片资源渲染 
	 * @author yeah
	 */	
	public class ShapeImage extends Shape
	{
		public function ShapeImage()
		{
			super();
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

		
		private var _source:Object;
		/**
		 *数据源 String or Bitmapdata
		 */
		public function get source():Object
		{
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set source(value:Object):void
		{
			if(_source == value) return;
			_source = value;
			//根据String or Bitmapdata进行解析
			setBitmapData(_source as BitmapData);
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
		
		/**
		 * BitmapData
		 */		
		protected var bitmapData:BitmapData;
		
		/**
		 *设置 BitmapData
		 * @param $bitmapData
		 */		
		protected function setBitmapData($bitmapData:BitmapData):void
		{
			if(this.bitmapData == $bitmapData) return;
			this.bitmapData = $bitmapData;
			invalidate();
		}
		
		/**
		 *矩阵 
		 */		
		private static var matrix:Matrix = new Matrix();
		
		/**
		 *提交渲染生效 
		 */		
		protected function commitRender():void
		{
			this.graphics.clear();
			if(!bitmapData) 
			{
				commintSize();
				return;
			}
			
			var measureWidth:Number = isNaN(explicitWidth) ? bitmapData.width : explicitWidth;
			var measureHeight:Number = isNaN(explicitHeight) ? bitmapData.height : explicitHeight;
			
			var bmd:BitmapData;
			if(scale9Rect)			
			{
				bmd = (isNaN(explicitWidth) && isNaN(explicitHeight)) ? bitmapData : getS9RBitmapData(measureWidth, measureHeight);
				matrix.identity();
			}
			else 
			{
				matrix.identity();
				if(!useRepeat)
				{
					matrix.a = measureWidth/bitmapData.width;
					matrix.d = measureHeight/bitmapData.height;
				}
				bmd = bitmapData;
			}
			this.graphics.beginBitmapFill(bmd, matrix, useRepeat, smooth);
			this.graphics.drawRect(0, 0, measureWidth, measureHeight);
			this.graphics.endFill();
		}
		
		/**
		 *获取根据九宫格缩放后的bitmapdata
		 */		
		private function getS9RBitmapData($unscaledWidth:Number, $unscaledHeight:Number):BitmapData
		{
			matrix.identity();
			var b:BitmapData = new BitmapData(500, 200);
			matrix.tx = 71;
			matrix.a = 2;
			b.draw(bitmapData, matrix, null, null, new Rectangle(71, 73, 71, 73));
			return b;
				
			
			/**最右边和最下面的宽高*/
			var rightW:Number = bitmapData.width - scale9Rect.right;
			var bottomH:Number = bitmapData.height - scale9Rect.bottom;
			
			/**将要进行缩放的宽高*/
			var scaledW:Number = $unscaledWidth - rightW - scale9Rect.x;
			var scaledH:Number = $unscaledHeight - bottomH - scale9Rect.y;
			
			/** 二维数组[[实际值，缩放值],[实际值，缩放值],....]** */
			var wList:Array = [[scale9Rect.x, scale9Rect.x], [scale9Rect.width, scaledW], [rightW, rightW]];
			var hList:Array = [[scale9Rect.y, scale9Rect.y], [scale9Rect.height, scaledH], [bottomH, bottomH]];
			
			matrix.identity();
			var bmd:BitmapData = new BitmapData($unscaledWidth, $unscaledHeight);
			var rect:Rectangle = new Rectangle();
			for each (var hArray:Array in wList) 
			{
				rect.y = 0;
				matrix.tx = 0;
				matrix.ty = 0;
				for each (var vArray:Array in hList) 
				{
					rect.width = hArray[0];
					rect.height = vArray[0];
					
					
					matrix.a = hArray[1]/hArray[0];
					matrix.d = vArray[1]/vArray[0];
					trace(matrix);
					bmd.draw(bitmapData, matrix, null, null, rect);
					
					matrix.tx += hArray[1];
					matrix.ty += vArray[1];
					rect.y += rect.width;
				}
				rect.x += hArray[0];
			}
			return bmd;
		}
		
		/**
		 *尺寸测量
		 */		
		protected function commintSize():void
		{
			_width = isNaN(explicitWidth) ? super.width : explicitWidth;
			_height = isNaN(explicitHeight) ? super.height : explicitHeight;
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
			if(waitValidate || !bitmapData) return;
			waitValidate = true;
			Global.instance.stage.addEventListener(Event.RENDER, validate);
			this.addEventListener(Event.ENTER_FRAME, validate);
		}
		
		/**
		 * 生效
		 * @param $e
		 */		
		private function validate($e:Event = null):void
		{
			waitValidate = false;
			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME, validate);
			}
			if(Global.instance.stage.hasEventListener(Event.RENDER))
			{
				Global.instance.stage.removeEventListener(Event.RENDER, validate);
			}
			commitRender();
			commintSize();
			
			if(this.hasEventListener(UIEvent.UPDATE_COMPLETE))
			{
				this.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
			}
		}
	}
}