package xlib.extension.display.clip.manager
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class ClipAssetsManager
	{
		private var bmdDic:Dictionary;
		
		public function addBitmapData($key:Object, $value:BitmapData):void
		{
			if(!bmdDic)
			{
				bmdDic = new Dictionary();
			}
			
			this.bmdDic[$key] = $value;
		}
		
		public function getBitmapData($key:Object):BitmapData
		{
			if(!bmdDic) return null;
			return bmdDic[$key];
		}
		
		public function hasBitmapData($key:Object):Boolean
		{
			return (bmdDic && $key in bmdDic);
		}
		
		public function ClipAssetsManager()
		{
		}
		
		private static var _instance:ClipAssetsManager;

		public static function get instance():ClipAssetsManager
		{
			if(!_instance)
			{
				_instance = new ClipAssetsManager();
			}
			return _instance;
		}

	}
}