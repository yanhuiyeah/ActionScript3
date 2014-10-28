package xlib.framework.theme
{
	import flash.errors.IllegalOperationError;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;

	/**
	 *主体工具类 
	 * @author yeah
	 */	
	public class ThemeUtil
	{
		
		/**普通*/
		public static const defaultTransform:ColorTransform=new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		/**变灰*/
		public static const fadeTransform:ColorTransform = new ColorTransform(.3, .4, .3, 1, 30, 40, 30, 0);
		/**高亮*/
		public static const highLightTransform:ColorTransform=new ColorTransform(1, 1, 1, 1, 50, 50, 0, 0);

		
		public function ThemeUtil()
		{
			throw new IllegalOperationError("静态类不能被实例化");
		}
	}
}