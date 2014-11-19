package xlib.framework.components
{
	import flash.display.DisplayObject;
	
	import xlib.framework.manager.supportClasses.ISkinParser;
	import xlib.framework.core.Component;
	import xlib.framework.core.interfaces.IInvalidateElement;
	import xlib.framework.core.interfaces.ILayoutElement;
	
	/**
	 *资源呈现器 （非容器，请勿做相关容器操作）
	 * @author yeah
	 */	
	public class AssetsRenderer extends Component
	{
		public function AssetsRenderer()
		{
			super();
		}
		
		
		private var skinChanged:Boolean = false;
		private var _skin:Object;

		/**
		 *皮肤对象
		 */
		public function get skin():Object
		{
			return _skin;
		}

		/**
		 * @private
		 */
		public function set skin(value:Object):void
		{
			if(_skin == value) return;
			_skin = value;
			
			if(skinParser)
			{
				skinParser.parser(skin, updateSkin);
			}
			else
			{
				skinChanged = true;
			}
		}
		
		private var _skinParser:ISkinParser;
		/**
		 *皮肤解析器 
		 */
		public function get skinParser():ISkinParser
		{
			return _skinParser;
		}
		
		/**
		 * @private
		 */
		public function set skinParser(value:ISkinParser):void
		{
			if(_skinParser == value) return;
			_skinParser = value;
			if(!skinParser) return;
			
			if(skinChanged)
			{
				skinParser.parser(skin, updateSkin);
				skinChanged = false;
			}
		}
		
		/**
		 *创建默认皮肤解析器 
		 * @return 
		 */		
		protected function createSkinParser():ISkinParser
		{
			//返回默认的解析器
		}
		
		private var displaySkinChanged:Boolean = false;
		private var _displaySkin:DisplayObject;
		/**
		 *解析后的皮肤显示对象 
		 * @return 
		 */		
		public function get displaySkin():DisplayObject
		{
			return _displaySkin;
		}
		
		/**
		 *设置解析后的皮肤显示对象 
		 * @param $value
		 */		
		private function setDisplaySkin($value:DisplayObject):void
		{
			if(_displaySkin == $value) return;
			_displaySkin = $value;
			displaySkinChanged = true;
			invalidateProperties();
			invalidateSize();
		}
		
		/**
		 * 更新皮肤 
		 * @param $parserdSkin 解析后的皮肤对象
		 */		
		protected function updateSkin($parserdSkin:Object):void
		{
			setDisplaySkin($parserdSkin as DisplayObject);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(!skinParser)
			{
				skinParser = createSkinParser();
				if(!skinParser)
				{
					trace("skinParser为空，请设置skinParser-皮肤解析器");
				}
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(displaySkinChanged)
			{
				if(numChildren > 0)
				{
					this.removeChildAt(0);
				}
				
				if(displaySkin)
				{
					this.addChildAt(displaySkin, 0);
				}
				displaySkinChanged = false;
			}
		}
		
		override protected function measure():void
		{
			if(displaySkin)
			{
				if(displaySkin is IInvalidateElement)
				{
					this.measuredWidth = IInvalidateElement(displaySkin).measuredWidth;
					this.measuredHeight = IInvalidateElement(displaySkin).measuredHeight;
				}
				else
				{
					this.measuredWidth = displaySkin.width;
					this.measuredHeight = displaySkin.height;
				}
			}
			else
			{
				super.measure();
			}
		}
		
		override protected function updateDisplayList($width:Number, $height:Number):void
		{
			if(displaySkin)
			{
				if(displaySkin is ILayoutElement)
				{
					ILayoutElement(displaySkin).setLayoutSize($width, $height);
				}
				else
				{
					this.displaySkin.width = $width;
					this.displaySkin.height = $height;
				}
			}
		}

	}
}