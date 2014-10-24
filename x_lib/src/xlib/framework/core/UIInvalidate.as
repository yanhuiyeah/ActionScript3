package xlib.framework.core
{
	import flash.events.IEventDispatcher;
	
	import xlib.framework.core.interfaces.IInvalidateElement;
	import xlib.framework.events.UIEvent;
	import xlib.framework.xlib_internal;
	
	use namespace xlib_internal;
	
	/**初始化完成*/
	[Event(name="initialized", type="xlib.framework.events.UIEvent")]
	/**本次延时生效更新完成*/
	[Event(name="updateComplete", type="xlib.framework.events.UIEvent")]
	
	/**
	 *可延时生效的Element
	 * @author yeah
	 */	
	public class UIInvalidate extends UISprite implements IInvalidateElement
	{
		public function UIInvalidate()
		{
			super();
		}

		/***测量宽度*/		
		xlib_internal var measuredWidth:Number = NaN;
		/**外部显示设置的宽度*/
		xlib_internal var expliciteWidth:Number = NaN;
		
		xlib_internal var _width:Number = NaN;
		override public function get width():Number
		{
			return !isNaN(_width) ? _width : 0;
		}

		override public function set width(value:Number):void
		{
			if(expliciteWidth == value) return;
			expliciteWidth = value;
			if(_width == value) return;
			_width = value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 *根据优先级获取宽度 
		 * expliciteWidth > measuredWidth;
		 * @return 
		 */		
		protected function get priorityWidth():Number
		{
			var pw:Number = isNaN(expliciteWidth) ? measuredWidth : expliciteHeight;
			return !isNaN(pw) ? pw : 0;
		}

		/***测量高度*/		
		xlib_internal var measuredHeight:Number = NaN;
		/**外部显示设置的高度*/
		xlib_internal var expliciteHeight:Number = NaN;
		
		xlib_internal var _height:Number = NaN;
		override public function get height():Number
		{
			return !isNaN(_height) ? _height : 0;
		}

		override public function set height(value:Number):void
		{
			if(expliciteHeight == value) return;
			expliciteHeight = value;
			if(_height == value) return;
			_height = value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 *根据优先级获取高度
		 * expliciteHeight > measuredHeight;
		 * @return 
		 */		
		protected function get priorityHeight():Number
		{
			var pw:Number = isNaN(expliciteHeight) ? measuredHeight : expliciteHeight;
			return !isNaN(pw) ? pw : 0;
		}
		
		private var _initialized:Boolean = false;
		public function set initialized($value:Boolean):void
		{
			if(_initialized == $value) return;
			_initialized = $value;
			if(!_initialized) return;
			if(this.hasEventListener(UIEvent.INITIALIZED))
			{
				this.dispatchEvent(new UIEvent(UIEvent.INITIALIZED));
			}
		}
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		private var _nestLevel:int = 0;
		public function set nestLevel($value:int):void
		{
			if(_nestLevel == $value) return;
			_nestLevel = $value;
			if(numChildren < 1) return;
			
			var childNL:int = _nestLevel + 1;
			var element:IInvalidateElement;
			for(var i:int = 0 ; i < numChildren; i++)
			{
				element = this.getChildAt(i) as IInvalidateElement;
				if(!element) continue;
				element.nestLevel = childNL;
			}
		}
		
		public function get nestLevel():int
		{
			return _nestLevel;
		}
		
		private var _updateCompletePendingFlag:Boolean = false;
		public function set updateCompletePendingFlag($value:Boolean):void
		{
			if(_updateCompletePendingFlag == $value) return;
			_updateCompletePendingFlag = $value;
			if(_updateCompletePendingFlag)
			{
				this.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
			}
		}
		
		public function get updateCompletePendingFlag():Boolean
		{
			return _updateCompletePendingFlag;
		}
		
		private var propertiesDirty:Boolean = false;
		public function invalidateProperties():void
		{
			if(propertiesDirty) return;
			propertiesDirty = true;
			Global.instance.renderManager.invalidateProperties(this);
		}
		
		private var sizeDirty:Boolean = false;
		public function invalidateSize():void
		{
			if(sizeDirty) return;
			sizeDirty = true;
			Global.instance.renderManager.invalidateSize(this);
		}
		
		private var displayListDirty:Boolean = false;
		public function invalidateDisplayList():void
		{
			if(displayListDirty) return;
			displayListDirty = true;
			Global.instance.renderManager.invalidateDisplayList(this);
		}
		
		public function validateProperties():void
		{
			if(!propertiesDirty) return;
			commitProperties();
			propertiesDirty = false;
		}
		
		public function validateSize($validateChild:Boolean = false):void
		{
			if($validateChild)
			{
				var element:IInvalidateElement;
				for (var i:int = 0; i < numChildren; i++) 
				{
					element = this.getChildAt(i) as IInvalidateElement;
					if(!element) continue;
					element.validateSize(true);
				}
			}
			
			if(!sizeDirty) return;
			
			if(measureSize())
			{
				invalidateDisplayList();
//				invalidateParent();
			}
			sizeDirty = false;
		}
		
		public function validateDisplayList():void
		{
			if(!displayListDirty) return;
			var w:Number = priorityWidth;
			var h:Number = priorityHeight;
			setActualSize(w, h);
			updateDisplayList(w, h);
			displayListDirty = false;
		}
		
		public function validateNow():void
		{
			Global.instance.renderManager.validateElement(this);
		}
		
		/**
		 *提交属性 
		 */		
		protected function commitProperties():void
		{
		}
		
		private var oldWidth:Number = NaN;
		private var oldHeight:Number = NaN;
		
		/**
		 *测量尺寸 
		 * @return 返回尺寸是否发生变化 
		 */		
		xlib_internal function measureSize():Boolean
		{
			if(isNaN(expliciteWidth) || isNaN(expliciteHeight))
			{
				measure();
			}
			
			var sizeChanged:Boolean = false;
			if(isNaN(oldWidth) || isNaN(oldHeight))
			{
				oldWidth = priorityWidth;
				oldHeight = priorityHeight;
				sizeChanged = true;
			}
			else if(oldWidth != priorityWidth || oldHeight != priorityHeight)
			{
				oldWidth = priorityWidth;
				oldHeight = priorityHeight;
				sizeChanged = true;
			}
			
			return sizeChanged;
		}
		
		/**
		 *测量 
		 */		
		protected function measure():void
		{
			measuredWidth = super.width;
			measuredHeight = super.height;			
		}
		
		/**
		 *更新显示列表 
		 * @param $width
		 * @param $height
		 */		
		protected function updateDisplayList($width:Number, $height:Number):void
		{
		}
		
//		/**
//		 *父容器 尺寸测量和显示列表更新 失效 
//		 */		
//		protected function invalidateParent():void
//		{
//			var p:IInvalidateElement = parent as IInvalidateElement;
//			if(p)
//			{
//				p.invalidateSize();
//				p.invalidateDisplayList();
//			}
//		}
		
		/**
		 * 设置宽高<br>
		 *调用此方法设置宽高不会进行测量，并且不会改变explicitWidth、explicitHeight;
		 * @param $width
		 * @param $height
		 */		
		public function setActualSize($width:Number, $height:Number):void
		{
			var changed:Boolean;
			if(_width != $width)
			{
				_width = $width;
				changed = true;
			}
			
			if(_height != $height)
			{
				_height = $height;
				changed = true;
			}
			
			if(changed)
			{
				invalidateDisplayList();
				this.dispatchEvent(new UIEvent(UIEvent.RESIZE));
			}
		}
	}
}