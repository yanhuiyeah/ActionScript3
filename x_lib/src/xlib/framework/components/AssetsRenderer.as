package xlib.framework.components
{
	import flash.display.DisplayObject;
	
	import xlib.framework.core.Component;
	import xlib.framework.core.interfaces.IInvalidateElement;
	import xlib.framework.core.interfaces.ILayoutElement;
	import xlib.framework.manager.Injector;
	import xlib.framework.manager.supportClasses.ISkinParser;
	
	/**
	 *资源呈现器 （非容器，请勿做相关容器操作）<br>
	 * 设置skin可自动解析（通过ISkinParser解析）并且呈现
	 * @author yeah
	 */	
	public class AssetsRenderer extends Component
	{
		public function AssetsRenderer()
		{
			super();
		}
		
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
			skinParser.parser(skin, updateSkin);
		}
		
		/**
		 *创建默认皮肤解析器 （子类可重写）
		 * @return 
		 */		
		protected function createSkinParser():ISkinParser
		{
			return Injector.instance.pull(ISkinParser);;
		}
		
		
		private var parsedSkinChanged:Boolean = false;
		private var _parsedSkin:Object;
		/**
		 *解析后的皮肤显示对象 
		 * @return 
		 */		
		public function get parsedSkin():Object
		{
			return _parsedSkin;
		}
		
		/**
		 *上次的skin 
		 */		
		private var lastSkin:Object;
		
		/**
		 * 更新皮肤 
		 * @param $parserdSkin 解析后的皮肤对象
		 */		
		private function updateSkin($parserdSkin:Object):void
		{
			if(_parsedSkin == $parserdSkin) return;
			lastSkin = _parsedSkin;
			_parsedSkin = $parserdSkin;
			parsedSkinChanged = true;
			invalidateProperties();
			invalidateSize();
		}
		
		/**
		 *提交skin 属性 
		 */		
		private function validateSkin():void
		{
			if(this.lastSkin)	
			{
				detachSkin(lastSkin);
				this.lastSkin = null;
			}
			attachSkin(parsedSkin);
		}
		
		/**
		 *附着皮肤 
		 * @param $skin
		 */		
		protected function attachSkin($skin:Object):void
		{
			var displaySkin:DisplayObject = $skin as DisplayObject;
			if(!displaySkin) return;
			this.addChildAt(displaySkin, 0);
		}

		/**
		 *分离皮肤
		 * @param $skin
		 */		
		protected function detachSkin($skin:Object):void
		{
			var displaySkin:DisplayObject = $skin as DisplayObject;
			if(displaySkin)
			{
				this.removeChild(displaySkin);
			}
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
			
			if(parsedSkinChanged)
			{
				validateSkin();
				parsedSkinChanged = false;
			}
		}
		
		override protected function measure():void
		{
			if(parsedSkin)
			{
				if(parsedSkin is IInvalidateElement)
				{
					this.measuredWidth = IInvalidateElement(parsedSkin).measuredWidth;
					this.measuredHeight = IInvalidateElement(parsedSkin).measuredHeight;
				}
				else
				{
					this.measuredWidth = parsedSkin.width;
					this.measuredHeight = parsedSkin.height;
				}
			}
			else
			{
				super.measure();
			}
		}
		
		override protected function updateDisplayList($width:Number, $height:Number):void
		{
			if(parsedSkin)
			{
				if(parsedSkin is ILayoutElement)
				{
					ILayoutElement(parsedSkin).setLayoutSize($width, $height);
				}
				else
				{
					this.parsedSkin.width = $width;
					this.parsedSkin.height = $height;
				}
			}
		}

	}
}