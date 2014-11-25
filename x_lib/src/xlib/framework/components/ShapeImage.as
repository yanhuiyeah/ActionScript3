package xlib.framework.components
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import xlib.framework.core.Global;
	import xlib.framework.events.UIEvent;
	
	/**
	 *更新完成的事件 
	 */	
	[Event(name="updateComplete", type="xlib.framework.events.UIEvent")]
	
	/**
	 *图片渲染器<br>
	 * 渲染完成后派发UIEvent.updateComplete, 此时的尺寸是正确的
	 * <br>
	 * 因为同步有问题 所以暂时废弃
	 * @author yeah
	 */	
	public class ShapeImage extends Shape
	{
		/**
		 * 构造函数
		 * @param $bitmapData	bitmapdata数据源
		 * @param $rect				缩放用的九宫格
		 */		
		public function ShapeImage($bitmapData:BitmapData = null, $rect:Rectangle = null)
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
			_width = bitmapData.width;
			_height = bitmapData.height;
			invalidate();
		}
		
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
				bmd = (isNaN(explicitWidth) && isNaN(explicitHeight)) ? bitmapData : getScaledBitmapData(bitmapData, scale9Rect, measureWidth, measureHeight);
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
			if(!waitValidate) return;
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