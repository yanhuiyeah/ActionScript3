package com.encoder
{
	import com.encoder.data.FileData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	
	public class FileProcessor
	{
		/**
		 *操作文件行为
		 */		
		private var openFile:File;
		
		/**
		 *打开 
		 */		
		public function open():void
		{
			if(!openFile)
			{
				openFile = new File();
				openFile.addEventListener(FileListEvent.SELECT_MULTIPLE, selectMultipleFile);
			}
			
			try
			{
				openFile.browseForOpenMultiple("package");
			}
			catch ($error:Error)
			{
				trace("打开文件失败：", $error.message);
			}
		}
		
		/**
		 *文件个数 
		 */		
		private var fileCount:int = 0;
		
		/**
		 *filedata列表 
		 */		
		private  var fileDataList:Vector.<FileData>;
		
		/**
		 *选中多个文件 
		 * @param event
		 */		
		private function selectMultipleFile(event:FileListEvent):void
		{
			var fileList:Array = event.files;
			fileCount = fileList ? fileList.length : 0;
			if(fileCount == 0) return;
			
			if(!fileDataList)
			{
				fileDataList = new Vector.<FileData>();
			}
			else
			{
				fileDataList.length = 0;
			}
			
			var index:int = 0;
			var len:int = fileList.length;
			while(index < len)
			{
				var fs:FileStream = new FileStream();
				var file:File = fileList.shift();
				var fileData:FileData = new FileData();
				fileData.index = index;
				fileData.name = file.name;
				fileData.extension = file.extension;
				fs.open(file, FileMode.READ);
				readByes(fs, fileData);
				fs.close();
				index++;
			}
		}		
		
		/**
		 *加载二进制流 
		 * @param $fs
		 * @param $fileData
		 */		
		private function readByes($fs:FileStream, $fileData:FileData):void
		{
			if($fileData.extension == "png" || $fileData.extension == "jpg")
			{
			}
			else
			{
				$fileData.bytes = new ByteArray();
				$fs.readBytes($fileData.bytes);
				readComplete($fileData);
			}
		}
		
		/**
		 *读取二进制流 
		 */		
		private function readComplete($fileData:FileData):void
		{
			this.fileDataList.push($fileData);
			
			if(this.fileDataList.length == fileCount)
			{
				
			}
			
			
//			var bytes:ByteArray = new ByteArray();
//			$fs.readBytes(bytes);
//			
//			var bmd:BitmapData = new BitmapData(500,500);
//			bmd.setPixels(new Rectangle(0,0,100,100), bytes);
//			ui.rawChildren.addChild(new Bitmap(bmd));
//			return;
//			
//			var loader:Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
//			try
//			{
//				loader.loadBytes(bytes);
//			}
//			catch($e:Error)
//			{
//				trace($e.message);
//			}
		}
		
//		/**
//		 *文件加载成功 
//		 * @param event
//		 */		
//		private function onLoaderComplete(event:Event):void
//		{
//		}
		
		//========================================
		
		private static var _instance:FileProcessor;
		public static function get instance():FileProcessor
		{
			if(!_instance)
			{
				_instance = new FileProcessor();
			}
			return _instance;
		}

		
		public function FileProcessor()
		{
		}
	}
}