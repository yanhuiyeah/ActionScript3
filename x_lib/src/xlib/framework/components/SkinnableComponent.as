package xlib.framework.components
{
	/**
	 *可设置外观并绑定皮肤属性的组件<br> 
	 * 非容器
	 * @author yeah
	 */	
	public class SkinnableComponent extends SkinRenderer
	{
		public function SkinnableComponent()
		{
			super();
		}
		
		/**
		 * 需绑定的part（子类重写）
		 * @return 
		 */		
		protected function get skinParts():Object
		{
			return null;
		}
		
		override protected function attachSkin($skin:Object):void
		{
			clearBoundParts();
			findBindableParts($skin);
			super.attachSkin($skin);
		}
		
		override protected function detachSkin($skin:Object):void
		{
			super.detachSkin($skin);
			clearBoundParts();
		}
		
		/**
		 *寻找可绑定的属性 
		 * @param $skin
		 */		
		protected function findBindableParts($skin:Object):void
		{
			var parts:Object = skinParts;
			if(!parts) return;
			for each (var obj:Object in parts) 
			{
				if(obj in this && obj in $skin)
				{
					var bindValue:Object = $skin[obj];
					this[obj] = bindValue;
					partUnBound(obj.toString(), bindValue);
				}
				else
				{
					throw new Error("请检测属性：" + obj);
				}
			}
		}
		
		/**
		 *清除已经绑定的属性 
		 */		
		protected function clearBoundParts():void
		{
			var parts:Object = skinParts;
			if(!parts) return;
			for each (var obj:Object in parts) 
			{
				if(obj in this)
				{
					this[obj] = null;
					partUnBound(obj.toString(), this[obj]);
				}
			}
		}
		
		/**
		 * 绑定属性
		 * @param $name		属性名称
		 * @param $value			被绑定的属性值
		 */		
		protected function partBound($name:String, $value:Object):void
		{
		}
		
		/**
		 * 解除属性绑定
		 * @param $name		属性名称
		 * @param $value			解除绑定的属性
		 */		
		protected function partUnBound($name:String, $value:Object):void
		{
		}
	}
}