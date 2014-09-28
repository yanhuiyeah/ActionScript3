package com
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;

	public class ToolsUtil
	{
		public function ToolsUtil()
		{
		}
		
		
		/**
		 *执行本地程序 
		 * @param exeURL			可执行的exe的路径比如 File.desktopDirectory.nativePath + "\\打飞机.exe";
		 * @param $callBack			当调用的可执行文件执行的时候调用; param:e:NativeProcessExitEvent
		 * @param $cmdURL		本机cmd.exe命令的路径；如果为空则默认：C:/Windows/System32/cmd.exe
		 */		
		public static function execute(exeURL:String, $callBack:Function = null, $cmdURL:String = null):void
		{
			if($cmdURL == null)
			{
				$cmdURL = "C:/Windows/System32/cmd.exe";
			}
			
			var file:File = new File($cmdURL);
			if(!file.exists)
			{
				Alert.show("你的cmd路径不是：" + $cmdURL);
			}
			else
			{
				try{
					NativeApplication.nativeApplication.autoExit=true;
					var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
					nativeProcessStartupInfo.executable = file;
					var args:Vector.<String> = new Vector.<String>;
					args.push("/c");
					args.push($cmdURL);
					nativeProcessStartupInfo.arguments = args;
					var process:NativeProcess = new NativeProcess();
					process.addEventListener(NativeProcessExitEvent.EXIT, processComplete);
					process.start(nativeProcessStartupInfo);
					function processComplete(e:NativeProcessExitEvent):void
					{
						if($callBack != null)
						{
							$callBack.call(null, e);
						}
						trace(exeURL, "已经启动了!");
					}
				}catch(e:Error){
					Alert.show(e.message + e.getStackTrace());
				}
			}
		}
	}
}