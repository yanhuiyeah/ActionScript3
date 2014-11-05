package xlib.extension.display.clip.data
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import xlib.extension.display.clip.insterfaces.IFrameData;
	
	/**
	 *需要解析的数据 
	 * @author yeah
	 */	
	public class ClipParserData extends ClipData
	{
		public function ClipParserData($dispatcher:IEventDispatcher=null, $autoCreate:Boolean=true)
		{
			super($dispatcher, $autoCreate);
		}
		
		/**
		 *解析数据 
		 * @param $source			序列帧图片资源样张
		 * @param $config			图片配置（分割图片用）
		 * @param $labelName		图片配置中读取frameLabel的名称
		 */		
		public function parserData($source:BitmapData, $config:XML, $labelName:String = null):void
		{
			for each (var node:XML in $config.children()) 
			{
				parserConfigNode(node, $source, $labelName);
			}
		}
		
		/**
		 *解析配置节点 
		 * @param $node
		 * @param $source
		 * @return 
		 */		
		protected function parserConfigNode($node:XML, $source:BitmapData, $labelName:String):IFrameData
		{
			var fd:IFrameData = new FrameData();
			var rect:Rectangle = new Rectangle();
			var frameLabel:String = "main";
			var xmlAttributes:XMLList = $node.attributes();
			for each(var xml:XML in xmlAttributes)
			{
				var name:String = xml.name();
				var value:String = xml;
				switch(name)
				{
					case $labelName:
						frameLabel = xml;
						if(frameLabel.indexOf("_") != -1)
						{
							frameLabel = frameLabel.split("_")[0];
						}
						break;
				}
				
				if(name in rect)
				{
					rect[name] = int(value);
				}
				
			}
			
			var bmd:BitmapData = new BitmapData(rect.width, rect.height);
			bmd.draw($source, new Matrix(1, 0, 0, 1, -rect.x, -rect.y), null, null, bmd.rect);
			fd.data = bmd;
			addFrame(fd, frameLabel);
			return fd;
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	}
}