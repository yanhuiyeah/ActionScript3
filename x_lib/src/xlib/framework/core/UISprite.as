package xlib.framework.core
{
	import flash.display.Sprite;
	
	/**
	 *UISprite 
	 * @author yeah
	 */	
	public class UISprite extends Sprite
	{
		/**
		 *uiid 
		 */		
		private static var UI_ID:int = 0;
		
		private var _uniqueID:int;

		/**
		 *显示对象唯一id 
		 */
		public function get uniqueID():int
		{
			return _uniqueID;
		}

		
		public function UISprite()
		{
			_uniqueID = UI_ID++;
			super();
		}
	}
}