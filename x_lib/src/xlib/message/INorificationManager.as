package xlib.message
{

	/**
	 *消息处理器<br> 
	 * 每个INorificationProcessor有自己的有效区域<br>
	 * 如果想跨模块通讯可以
	 * @author yeah
	 */	
	public interface INorificationManager
	{
		
		/**
		 *注册消息观察者 
		 * Dictionary[$notification] = Vector.<INotificationObserver>[$observer,....];
		 * @param $observer
		 */		
		function registerObserver($notification:String, $observer:INotificationObserver):INotificationObserver;
		
		/**
		 *移除观察者 
		 * @param $observer
		 */		
		function removeObserver($observer:INotificationObserver):INotificationObserver;
		
		/**
		 *移除消息类型对应的观察者 
		 * @param $notification
		 */		
		function removeObservers($notification:String):void;
		
		/**
		 *发送消息<br> 
		 * 根据INotification.type 获取 INotificationObserver列表 遍历列表执行INotificationObserver.notify(INotification);
		 * @param $notifaction
		 */		
		function sendNotification($notifaction:INotification):void;
	}
}