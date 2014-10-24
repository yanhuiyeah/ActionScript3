package xlib.framework.core.interfaces
{
	/**
	 *component接口 
	 * @author yeah
	 */	
	public interface IComponent
	{
		/**
		 *组建是否激活 
		 */		
		function get enabled():Boolean;
		function set enabled($value:Boolean):void;
		
		/**
		 *tips 
		 */		
		function get toolTips():Object;
		function set toolTips($value:Object):void;
		
		/**
		 *移动 
		 * @param $x
		 * @param $y
		 */		
		function move($x:Number, $y:Number):void;
	}
}