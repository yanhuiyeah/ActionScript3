package xlib.framework.core.interfaces
{
	/**
	 *可自动布局的元素 
	 * @author yeah
	 */	
	public interface ILayoutElement extends IInvalidateElement
	{
		/**
		 *是否参与自动布局(默认true)
		 */		
		function get autoLayout():Boolean;
		function set autoLayout($value:Boolean):void;
		
		/**
		 *距离左边距离
		 */		
		function get left():Number;
		function set left($value:Number):void;
		
		/**
		 *距离右边距离
		 */		
		function get right():Number;
		function set right($value:Number):void;
		
		/**
		 *距离顶距离
		 */		
		function get top():Number;
		function set top($value:Number):void;
		
		/**
		 *距离底距离
		 */		
		function get bottom():Number;
		function set bottom($value:Number):void;
		
		/**
		 *垂直居中偏移量
		 */		
		function get verticalCenter():Number;
		function set verticalCenter($value:Number):void;
		
		/**
		 *水平居中偏移量
		 */		
		function get horizontalCenter():Number;
		function set horizontalCenter($value:Number):void;
		
		/**
		 *宽度百分比（相对与父容器, 0 - 100）
		 */		
		function get percentWidth():Number;
		function set percentWidth($value:Number):void;
		
		/**
		 *高度百分比（相对与父容器, 0 - 100）
		 */		
		function get percentHeight():Number;
		function set percentHeight($value:Number):void;
		
		/**
		 *设置布局尺寸 
		 * @param $width
		 * @param $height
		 */		
		function setLayoutSize($width:Number, $height:Number):void;
		
		/**
		 *设置位置 
		 * @param $x
		 * @param $y
		 */		
		function setLayoutPosition($x:Number, $y:Number):void;
		
		function get x():Number;
		function get y():Number;
	}
}