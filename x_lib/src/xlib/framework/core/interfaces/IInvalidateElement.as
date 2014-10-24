package xlib.framework.core.interfaces
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	/**
	 * 
	 * 延时生效Element接口<br>
	 * 组件只有实现IInvalidateElement接口才能参与布局延时生效(布局三个阶段：提交、测量、布局)<br>
	 * 
	 *注意：flash弹性跑道大体分三部分：<br>
	 * 	1.User Action (监听非Event.render事件，执行用户代码);<br>
	 * 	2.Invalidate Action (监听Event.render事件，执行用户代码);<br>
	 * 	3.Render Action (渲染);<br>
	 * 
	 * IInvalidateElement.invalidateProperties();  ------->>> 	IInvalidateElement.validateProperties()<br>
	 * IInvalidateElement.invalidateSize();           ------->>> 	IInvalidateElement.validateSize()<br>
	 * IInvalidateElement.invalidateDisplayList(); ------->>>  	IInvalidateElement.validateDisplayList()<br>
	 * @author yeah
	 */	
	public interface IInvalidateElement extends IEventDispatcher
	{
		/**一个标志，用于确定IInvalidateElement是否首次完成了布局验证的三个阶段(提交/度量/布局序列)*/
		function set initialized($value:Boolean):void;
		function get initialized():Boolean;
		
		/**
		 * 嵌套级别<br>
		 * nestLevel 用于在度量和布局阶段对 按照相应的顺序执行IInvalidateElement失效状态的提交<br>
		 * 在提交阶段，按 nestLevel 递减的顺序向客户端提交属性，这样，在提交对象本身的属性前，该对象的子项的属性即已提交。<br>
		 * 在度量阶段，nestLevel 递减的顺序测量客户端，这样，在测量对象本身前，该对象的子项即已完成测量。<br>
		 * 在布局阶段，nestLevel 递增的顺序布局客户端，这样，在布局本身子项后不会过多影响父对象。<br>
		 *  **/
		function get nestLevel():int;
		function set nestLevel($value:int):void;
		
		
		/**一个标志，用于确定某个对象是否正在等待调度其 updateComplete 事件（不要对其设置）**/
		function set updateCompletePendingFlag($value:Boolean):void;
		function get updateCompletePendingFlag():Boolean;
		
		//=======================invalidate================================
		/**
		 *属性提交失效 
		 * 调用此方法将导致在呈示显示列表前调用组件的 validateProperties() 方法。 
		 * 相关调用: commitProperties()。
		 */		
		function invalidateProperties():void;
		
		/**
		 *尺寸测量失效 
		 * 调用此方法将导致在呈示显示列表前调用组件的 validateSize() 方法。 
		 *  相关调用：measure()，除非组件设置了 explicitWidth 和 explicitHeight（外部显示设置了宽高）。
		 */		
		function invalidateSize():void;
		
		/**
		 *显示列表更新失效 
		 * 调用此方法将导致在呈示显示列表前调用组件的 validateDisplayList() 方法。 
		 * 相关调用: updateDisplayList()。
		 */		
		function invalidateDisplayList():void;
		//=======================validate================================
		
		/**
		 * 提交属性阶段调用
		 **/
		function validateProperties():void;
		
		
		/**
		 * 测量阶段调用
		 * @$validateChild 是否同时测量子对象
		 **/
		function validateSize($validateChild:Boolean = false):void;
		
		/**
		 * 布局阶段调用
		 **/
		function validateDisplayList():void;
		
		/**
		 *立即生效
		 */		
		function validateNow():void;
	}
}