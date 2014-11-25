package xlib.framework.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 *graphicsutil 
	 * @author yeah
	 */	
	public class GraphicsUtil
	{
	
		/**
		 * 根据9宫格绘制
		 * @param $source			源数据
		 * @param $s9r					九宫格
		 * @param $width			缩放后的宽度
		 * @param $height			缩放后的高度
		 * @param $target			画板BitmapData（缩放后的数据绘制到这上面），如果==null则创建一个
		 * @param $matrix			矩阵，如果==null则默认创建一个，否则$matrix.identity();
		 * @return 
		 */		
		public static function scaledBitmapData($source:BitmapData, $s9r:Rectangle, $width:Number, $height:Number, $target:BitmapData = null, $matrix:Matrix = null):BitmapData
		{
			if(!$matrix)
			{
				$matrix = new Matrix();
			}
			else
			{
				$matrix.identity();
			}
			
			if(!$target)
			{
				$target = new BitmapData($width, $height);
			}
			
			/**应该缩放的宽高*/
			var scaledW:Number = $width - $source.width + $s9r.width;
			var scaledH:Number = $height - $source.height + $s9r.height;
			
			/**未进行缩放的水平/竖直的点*/
			var hValues:Array = [$s9r.x, $s9r.width, $source.width - $s9r.right];
			var vValues:Array = [$s9r.y, $s9r.height, $source.height - $s9r.bottom];
			
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
				
				$matrix.a = scaledRect.width / unScaledRect.width;
				$matrix.tx = scaledRect.x - $matrix.a* unScaledRect.x;
				
				vScaled = true;
				for each (var v_value:int in vValues) 
				{
					vScaled = !vScaled;
					unScaledRect.height  = v_value;
					scaledRect.height  = !vScaled ? v_value : scaledH;
					
					$matrix.d = scaledRect.height / unScaledRect.height;
					$matrix.ty = scaledRect.y - $matrix.d * unScaledRect.y;
					
					$target.draw($source, $matrix, null, null, scaledRect);
					
					unScaledRect.y = unScaledRect.bottom;	
					scaledRect.y = scaledRect.bottom;	
				}
				
				unScaledRect.x = unScaledRect.right;
				scaledRect.x = scaledRect.right;
			}
			return $target;
		}
		
		
		
		
		public function GraphicsUtil()
		{
			throw new Error("GraphicsUtil is static class");
		}
	}
}