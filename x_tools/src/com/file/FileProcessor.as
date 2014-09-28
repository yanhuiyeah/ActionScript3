package com.file
{
	import com.file.data.FileData;
	
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
		/**只允许选择一个文件*/
		public static const ONE_FILE:uint = 0;
		/**允许选择多个文件*/
		public static const MORE_FILE:uint = 1;
		/**只允许文件夹*/
		public static const ONE_FOLDER:uint = 2;
		
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
		 * @param $callBack 		数据完全准备好后的回调；param:Vector.<FileData>
		 * @param $windowType  窗口打开类型；0:只允许选择一个文件 1：允许选择多个文件 2只允许文件夹
		 * @param $filters				 文件类型列表;	$windowType == 2时无效
		 */		
		public function open($callBack:Function, $windowType:uint = 1, $filters:Array = null):void
		{
			if(!openFile)
			{ 
				openFile = new File();
				openFile.addEventListener(FileListEvent.SELECT_MULTIPLE, selectMultipleFile);
				openFile.addEventListener(Event.SELECT, selectOne);
			}
			
			try
			{
				this.callBack = $callBack;
				
				switch($windowType)
				{
					case ONE_FILE:
						openFile.browseForOpen("请选择一个文件", $filters);
						break;
					case MORE_FILE:
						openFile.browseForOpenMultiple("请选择文件（可多选）", $filters);
						break;
					case ONE_FOLDER:
						openFile.browseForDirectory("请选择一个文件夹");
						break;
				}
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
		 *选择一个文件 
		 * @param $e
		 */		
		private function selectOne($e:Event):void
		{
			var f:File = $e.currentTarget as File;
			
			var fArray:Array = [];
			if(f.isDirectory)
			{
				fArray = f.getDirectoryListing();
			}
			else
			{
				fArray.push(f);
			}
			
			selectFiles(fArray);
		}
		
		/**
		 *选中多个文件 
		 * @param event
		 */		
		private function selectMultipleFile(event:FileListEvent):void
		{
			selectFiles(event.files);
		}		
		
		/**
		 *选择文件 
		 * @param $fileList
		 */		
		private function selectFiles($fileList:Array):void
		{
			fileCount = $fileList ? $fileList.length : 0;
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
			var len:int = $fileList.length;
			while(index < len)
			{
				var fs:FileStream = new FileStream();
				var file:File = $fileList.shift();
				var fileData:FileData = new FileData();
				fileData.index = index;
				fileData.name = file.name;
				fileData.url = file.url;
				fileData.nativePath = file.nativePath;
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
		
		/**用于保存文件的file*/
		private var saveFile:File;
		
		/**
		 *保存成功后的回调 
		 */		
		private var saveCallBack:Function;
		
		/**
		 * 保存 文件
		 * @param $data					需要保存的文件
		 * @param $defaultName		默认保存的文件名
		 * @param $callBack				保存成功的回调; param：event:Event (event.CurrentTarget is File;)
		 */		
		public function save($data:*, $defaultName:String = null, $callBack:Function = null):void
		{
			this.saveCallBack = $callBack;
			if(!saveFile)			
			{
				saveFile = new File();
				saveFile.addEventListener(Event.COMPLETE, saveComplete);
			}
			saveFile.save($data, $defaultName);
		}

		/**
		 *保存成功 
		 * @param event
		 */		
		private function saveComplete(event:Event):void
		{
			if(saveCallBack != null)
			{
				saveCallBack.call(null, event);
				saveCallBack = null;
			}
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
import com.file.data.FileData;

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