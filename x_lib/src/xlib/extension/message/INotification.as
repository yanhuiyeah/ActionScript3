package xlib.extension.message
{
	
	/**
	 *消息 
	 * @author yeah
	 */	
	public interface INotification
	{
		
		/**
		 *消息类型 
		 * @return 
		 */		
		function get type():String;
		function set type($value:String):void;
		
		/**
		 *数据 
		 * @return 
		 */		
		function get data():Object;
		function set data($value:Object):void;
	
	}
}