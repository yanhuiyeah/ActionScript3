package utils
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 *a星 
	 * @author yeah
	 */	
	public class AStar
	{
		
		private var _find:Boolean = false;

		/**
		 *是否找到 
		 */
		public function get find():Boolean
		{
			return _find;
		}
		
		
		public function AStar()
		{
		}
		
		
		/**
		 *执行 
		 * @param $map 			地图列表 二维 $map[c][r] = 0 普通 $map[c][r] = 1 障碍
		 * @param $startX		起始水平格子索引
		 * @param $startY		起始垂直格子索引
		 * @param $endX			结束水平格子索引
		 * @param $endY			结束垂直格子索引
		 * @return 					格子索引列表（二维数组）
		 */		
		public function execute($map:Array, $startX:int, $startY:int, $endX:int, $endY:int):Array
		{
			_find = false;
			
			/**开放列表*/
			var ol:Dictionary = new Dictionary();
			
			/**关闭列表*/
			var cl:Dictionary = new Dictionary();
			
			/**当前节点*/
			var cn:AStarNode = new AStarNode(null, $startX, $startY); 
			ol[$startX+"_"+$startY] = cn;
			
			/**总行数*/
			var tx:int = $map.length;
			/**当前行总列数*/
			var ty:int;
			
			while(true)
			{
				for (var i:int = -1; i < 2; i++) 
				{
					for (var j:int = -1; j < 2; j++) 
					{
						/**跳过本身*/
						if(i == 0 && j == 0) continue;
						
						var x:int = cn.x + i;
						if(x >= tx || x < 0) continue;
						
						var y:int = cn.y + j;
						ty = $map[x].length;
						if(y >= ty || y < 0) continue;

						var key:String = x+"_" + y;
						/**如果在关闭列表中则放弃*/					
						if(key in cl) continue;
						
						/**如果存在于开列表则继续下一个*/
						if(key in ol) continue;
						
						if($map[x][y] == 1) continue;
						
						var g:int = (x==0 || y == 0) ? 10 : 14;
						//此处计算g 应该是10 还是14;
						
						var on:AStarNode = new AStarNode(cn, x, y);
						on.g = cn.g + g;
						on.h = (Math.abs(x - $endX) + Math.abs(y - $endY)) * 10;
						on.f = on.g + on.h;
						ol[key] = on;
					}
				}
				
				delete ol[cn.x + "_" + cn.y];
				cl[cn.x + "_" + cn.y] = cn;
				
				cn = null;
				for each (var obj:AStarNode in ol) 
				{
					if(!cn)
					{
						cn = obj;
						continue;
					}
					
					if(obj.f < cn.f)
					{
						cn = obj;
					}
				}
				
				if(!cn) break;
				
				if(cn.x == $endX && cn.y == $endY)
				{
					_find = true;
					break;
				}
			}
			
			if(!cn) return null;
			
			var arr:Array = [];
			while(cn.p)
			{
				arr.push(new Point(cn.x, cn.y));
				cn = cn.p;
			}
			
			//此处计算路径
			return arr;
		}
	}
}

/**
 *节点 
 * @author yeah
 */
class AStarNode
{
	
	/**
	 *父节点 
	 */	
	public var p:AStarNode;
	
	/**
	 *垂直索引 
	 */	
	public var y:int;
	
	/**
	 *水平节点 
	 */	
	public var x:int;
	
	/**
	 *g f = g + h; 
	 */	
	public var g:int;
	
	/**
	 *h f = g + h; 
	 */	
	public var h:int;
	
	/**
	 *f = g + h; 
	 */	
	public var f:int;
	
	public function AStarNode($p:AStarNode, $x:int, $y:int)
	{
		this.p = $p;
		this.x = $x;
		this.y = $y;
	}
}
