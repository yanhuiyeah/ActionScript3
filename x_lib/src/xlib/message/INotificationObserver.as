package xlib.message
{
	/**
	 *消息观察者 
	 * @author yeah
	 */	
	public interface INotificationObserver
	{
		/**
		 *收到通知 
		 * @param $notification
		 */		
		function notify($notification:INotification):void;
	}
}