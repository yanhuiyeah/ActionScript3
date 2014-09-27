package com.transcoding.classgroup
{
	import com.transcoding.common.Transcoder;
	
	import flash.events.IEventDispatcher;
	
	/**
	 *数据转换成xml配置(能使用此xml生成类) 
	 * @author yeah
	 */	
	public class ClassData2XML extends Transcoder
	{
		public function ClassData2XML(target:IEventDispatcher=null)
		{
			super(target);
		}
		
	}
}