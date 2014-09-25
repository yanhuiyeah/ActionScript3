package com.encoder
{
	import com.encoder.data.FileData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	
	public class FileProcessor
	{
		
		/**
		 *全部流加载完成后回调 
		 */		
		private var callBack:Function;
		
		/**
		 *操作文件行为
		 */		
		private var openFile:File;
		
		/**
		 *打开选择框 
		 * @param $callBack param:Vector.<FileData>
		 */		
		public function open($callBack:Function):void
		{
			if(!openFile)
			{ 
				openFile = new File();
				openFile.addEventListener(FileListEvent.SELECT_MULTIPLE, selectMultipleFile);
			}
			
			try
			{
				this.callBack = $callBack;
				openFile.browseForOpenMultiple("package");
			}
			catch ($error:Error)
			{
				this.callBack = null;
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
			var bytes:ByteArray = new ByteArray();
			$fs.readBytes(bytes);
			if($fileData.extension == "png" || $fileData.extension == "jpg")
			{
				new BytesLoader(bytes, readComplete, $fileData);
			}
			else
			{
				readComplete($fileData, bytes);
			}
		}
		
		/**
		 *读取数据完成
		 */		
		private function readComplete($fileData:FileData, $data:Object):void
		{
			$fileData.data = $data;
			this.fileDataList.push($fileData);
			if(this.fileDataList.length == fileCount && this.callBack != null)
			{
				this.fileDataList.sort(sort);
				this.callBack.call(null, this.fileDataList.concat());
				this.fileDataList.length = 0;
				this.callBack = null;
			}
		}
		
		/**
		 *排序 
		 * @param $item1
		 * @param $item2
		 * @return 
		 */		
		private function sort($item1:FileData, $item2:FileData):int
		{
			if($item1.index > $item2.index)	
			{
				return 1;
			}
			else if($item1.index < $item2.index)
			{
				return -1;
			}
			
			return 0;
		}
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

//=============================
import com.encoder.data.FileData;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.utils.ByteArray;

class BytesLoader
{
	
	private var loader:Loader;
	
	private var callBack:Function;
	
	private var fileData:FileData;
	
	private var bytes:ByteArray;
	
	public function BytesLoader($bytes:ByteArray, $callBack:Function, $fileData:FileData)
	{
		this.fileData = $fileData;
		this.callBack = $callBack;
		this.bytes = $bytes;
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		loader.loadBytes(this.bytes);
	}
	
	private function loadComplete($e:Event):void
	{
		var contentLoaderInfo:LoaderInfo = $e.currentTarget as LoaderInfo;
		contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
		var bmd:BitmapData = Bitmap(contentLoaderInfo.content).bitmapData;
		if(this.callBack != null)
		{
			this.callBack.call(null, fileData, bmd);
		}
		desroty();
	}
	
	public function desroty():void
	{
		if(this.bytes)
		{
			this.bytes.clear();
			this.bytes = null;
		}
		
		if(loader)
		{
			loader.unload();
			this.loader = null;
		}
		this.callBack = null;
		this.fileData = null;
	}
	
	
}