package xlib.framework.manager.layout
{
	import flash.events.IEventDispatcher;
	
	import xlib.framework.core.interfaces.ILayoutElement;
	
	/**
	 *容器默认布局管理器 
	 * @author yeah
	 */	
	public class DefaultLayout extends LayoutBase
	{
		public function DefaultLayout($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		override public function measure():void
		{
			super.measure();
			if(!target) return;
			
			var maxW:Number = 0;
			var maxH:Number = 0;
			var len:int = target.numElements;
			var element:ILayoutElement;
			for (var i:int = 0; i < len; i++) 
			{
				element = target.getElementAt(i);
				if(!element || !element.autoLayout) continue;
				
				var offset:Number = 0;
				if(!isNaN(element.left) && !isNaN(element.right))
				{
					offset = element.left + element.right;
				}
				else if(!isNaN(element.horizontalCenter))
				{
					offset = (element.horizontalCenter > 0 ? element.horizontalCenter : -element.horizontalCenter) * 2;
				}
				else if(!isNaN(element.left) || !isNaN(element.right))
				{
					offset = (isNaN(element.left) ? 0 : element.left + isNaN(element.right) ? 0 : element.right)
				}
				else
				{
					offset = element.x;
				}
				
				offset += element.priorityWidth;
				maxW = maxW > offset ? maxW : offset;
				
				offset = 0;
				if(!isNaN(element.top) && !isNaN(element.bottom))
				{
					offset = element.top + element.bottom;
				}
				else if(!isNaN(element.verticalCenter))
				{
					offset = (element.verticalCenter  > 0 ? element.verticalCenter  : -element.verticalCenter )* 2;
				}
				else if(!isNaN(element.top) || !isNaN(element.bottom))
				{
					offset = (isNaN(element.top) ? 0 : element.top + isNaN(element.bottom) ? 0 : element.bottom)
				}
				else
				{
					offset = element.y;
				}
				maxH = maxH > offset ? maxW : offset;
			}
			
			target.measuredWidth = maxW + target.paddingLeft + target.paddingRight;
			target.measuredHeight = maxH + target.paddingTop + target.paddingBottom;
		}
		
		override public function updateDisplayList($width:Number, $height:Number):void
		{
			super.updateDisplayList($width, $height);	
			if(!target) return;
			
			var w:Number = $width - target.paddingLeft - target.paddingRight;
			var h:Number = $height - target.paddingTop - target.paddingBottom;
			
			var len:int = target.numElements;
			var element:ILayoutElement;
			for (var i:int = 0; i < len; i++) 
			{
				element = target.getElementAt(i);
				if(!element || !element.autoLayout) continue;
				
				var elementW:Number = NaN;
				var elementX:Number = 0;
				if(!isNaN(element.left) && !isNaN(element.right))
				{
					elementW = w - element.left - element.right;
				}
				else if(!isNaN(element.percentWidth))
				{
					elementW = Math.ceil(element.percentWidth * .001 * w);
				}
				
				if(!isNaN(element.horizontalCenter))
				{
					elementX = (w - element.priorityWidth) * .5 + element.horizontalCenter;
				}
				else if(!isNaN(element.left))
				{
					elementX = element.left;
				}
				else if(!isNaN(element.right))
				{
					elementX = w - element.priorityWidth - element.right;
				}
				else
				{
					elementX = element.x;
				}
				
				var elementH:Number = NaN;
				var elementY:Number = 0;
				if(!isNaN(element.top) && !isNaN(element.bottom))
				{
					elementH = h - element.top - element.bottom;
				}
				else if(!isNaN(element.percentHeight))
				{
					elementH = Math.ceil(element.percentHeight * .001 * h);
				}
				
				if(!isNaN(element.verticalCenter))
				{
					elementY = (h - element.priorityHeight) * .5 + element.verticalCenter;
				}
				else if(!isNaN(element.top))
				{
					elementY = element.top;
				}
				else if(!isNaN(element.bottom))
				{
					elementY = h - element.priorityWidth - element.bottom;
				}
				else
				{
					elementY = element.y;
				}
				
				element.setLayoutSize(elementW, elementH);
				element.setLayoutPosition(elementX, elementY);
			}
			
		}
	}
}