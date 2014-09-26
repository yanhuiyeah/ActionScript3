package com.core
{
	public class x_Log
	{
		public function x_Log()
		{
		}
		
		/**
		 *显示 
		 * @param args String
		 */		
		public static function show(...args):void
		{
			var text:String = "";
			for (var i:int = 0; i < args.length; i++) 
			{
				text += (args[i].toString() + " ");
			}
			trace(text);
		}
	}
}