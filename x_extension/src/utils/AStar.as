package utils
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *a星 
	 * @author yeah
	 */	
	public class AStar
	{
		
		public function AStar()
		{
		}
		
		/**
		 *寻路
		 * @param $map 			地图列表 二维 $map[c][r] = 0 普通 $map[c][r] > 0 障碍
		 * @param $start			起点格子索引（$start.x 水平索引， $start.y 竖直索引）
		 * @param $end			终点格子索引（$end.x 水平索引， $end.y 竖直索引）
		 * @$success					寻路成功回调函数（参数([[水平索引，竖直索引], [水平索引，竖直索引], [水平索引，竖直索引], .....])）
		 * @$error					寻路失败（失败提示）
		 */		
		public function find($map:Array, $start:Point, $end:Point, $success:Function, $error:Function = null):void
		{
			/**开放列表*/
			var ol:Dictionary = new Dictionary();
			
			/**关闭列表*/
			var cl:Dictionary = new Dictionary();
			
			/**当前节点*/
			var cn:AStarNode = new AStarNode(null, $start.x, $start.y); 
			ol[$start.x+"_"+$start.y] = cn;
			
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
						
						/**如果不允许通过继续下一个*/
						if($map[x][y] > 0) continue;
						
						/**此处计算g 应该是10 还是14;*/
						var g:int = (x==0 || y == 0) ? 10 : 14;
						
						var on:AStarNode = new AStarNode(cn, x, y);
						on.g = cn.g + g;
						on.h = (Math.abs(x - $end.x) + Math.abs(y - $end.y)) * 10;
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
				
				if(cn.x == $end.x && cn.y == $end.y)
				{
					break;
				}
			}
			
			if(cn) 
			{
				var path:Array = [];
				while(cn.p)
				{
					path.push(new Point(cn.x, cn.y));
					cn = cn.p;
				}
				
				if($success != null)
				{
					$success.call(null, path);
				}
			}
			else 
			{
				var error:String = "寻路失败";
				if($error != null) 
				{
					$error.call(null, error);
				}
				trace(error);
			}
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
