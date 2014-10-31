package xlib.extension.net
{
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class XSocket extends Socket
	{
		public function XSocket(host:String=null, port:int=0)
		{
			super(host, port);
		}
		
		/**消息长度*/
		private static var HEAD_LEN:int = 4;
		
		/**正在读取的数据缓存*/
		private var cacheBytes:ByteArray = new ByteArray();
		
		/**粘包数据缓存*/
		private var bufferByes:ByteArray = new ByteArray();
		
		/**
		 *整条消息结构：消息头(4+消息体长度) 
		 * @param e
		 */		
		private function socketDataHandler(e:ProgressEvent):void
		{
			cacheBytes.length = 0;
			readBytes(cacheBytes);
			cacheBytes.position = 0;
			
			//如果缓存数据不存在
			if(bufferByes.position == 0)
			{
				tryReadPacket(cacheBytes);
				
				if(cacheBytes.bytesAvailable > 0)
				{
					bufferByes.length = 0;
					bufferByes.writeBytes(cacheBytes);
				}
			}
			else
			{
				cacheBytes.readBytes(bufferByes, bufferByes.length, cacheBytes.length);
				
				tryReadPacket(bufferByes);
				
				if(bufferByes.bytesAvailable > 0)
				{
					var bytes:ByteArray = new ByteArray();
					bytes.writeBytes(bufferByes, bufferByes.position, bufferByes.bytesAvailable);
					bufferByes.length = bytes.length;
					bufferByes.position = 0;
					bufferByes.writeBytes(bytes);
					bytes.length = 0;
				}
				else
				{
					bufferByes.position = 0;
					bufferByes.length = 0;
				}
			}
		}
		
		/**
		 *尝试读取完整包（存在一个或者多个完整包） 
		 * @param $bytes
		 */		
		private function tryReadPacket($bytes:ByteArray):void
		{
			$bytes.position = 0;
			while($bytes.bytesAvailable >= HEAD_LEN)
			{
				var len:int = $bytes.readInt();
				if($bytes.bytesAvailable  >= len)
				{
					//读取消息体,处理逻辑
				}
				else
				{
					break;
				}
			}
		}
		
	}
}