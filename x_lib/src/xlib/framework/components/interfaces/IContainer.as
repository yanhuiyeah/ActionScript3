package xlib.framework.components.interfaces
{
	import xlib.framework.core.interfaces.IComponent;
	import xlib.framework.core.interfaces.ILayoutElement;

	/**
	 *容器 
	 * @author yeah
	 */	
	public interface IContainer extends IComponent
	{
		/**
		 *布局管理器 
		 */		
		function get layout():ILayout;
		function set layout($value:ILayout):void;
		
		/**
		 *容器内容左边距 
		 */		
		function get paddingLeft():Number;
		function set paddingLeft($value:Number):void;
		
		/**
		 *容器内容右边距 
		 */		
		function get paddingRight():Number;
		function set paddingRight($value:Number):void;
		
		/**
		 *容器内容上边距 
		 */		
		function get paddingTop():Number;
		function set paddingTop($value:Number):void;
		
		/**
		 *容器内容下边距 
		 */		
		function get paddingBottom():Number;
		function set paddingBottom($value:Number):void;
		
		/**
		 *获取子对象 
		 * @param $index
		 * @return 
		 */		
		function getElementAt($index:int):ILayoutElement;
		
		/**
		 *获取子显示对象个数 
		 */		
		function get numElements():int;
		
	}
}