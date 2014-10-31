package xlib.extension.display.clip.data
{
	import xlib.extension.display.clip.core.LazyDispatcher;
	import xlib.extension.display.clip.core.interfaceClass.IClipFrameData;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 *clip帧数据基类 
	 * 根据不通的IClipRender新增逻辑 
	 * 比如:ClipRenderer对应的ClipFrameBitpmapData
	 * @author yeah
	 */	
	public class ClipFrameData extends LazyDispatcher implements IClipFrameData
	{
		public function ClipFrameData($dispatcher:EventDispatcher=null)
		{
			super($dispatcher);
		}
		
		private var _offset:Point;
		public function get offset():Point
		{
			return this._offset;
		}
		
		public function set offset($value:Point):void
		{
			this._offset = $value;
		}
		
		private var _frameLabel:String;
		public function get frameLabel():String
		{
			return this._frameLabel;
		}
		
		public function set frameLabel($value:String):void
		{
			this._frameLabel = $value;
		}
		
		public function destroy($cleanDispather:Boolean):void
		{
		}
	}
}