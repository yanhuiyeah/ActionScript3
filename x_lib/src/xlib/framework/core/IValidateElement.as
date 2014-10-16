package xlib.framework.core
{
	import flash.events.IEventDispatcher;
	
	/**
	 *延时生效element 
	 * @author yeah
	 */	
	public interface IValidateElement extends IEventDispatcher
	{
		/**
		 *生效 
		 * @param $type	生效类型
		 */		
		function validate($type:String):void;
		
		/**
		 *布局生效代理 
		 * @return 
		 */		
		function get validateProxy():ValidateProxy;
		
		/**
		 * 嵌套级别<br>
		 *  **/
		function set nestLevel($value:int):void;
		function get nestLevel():int;
	}
}