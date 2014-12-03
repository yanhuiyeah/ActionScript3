package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import utils.AStar;
	
	import xlib.framework.Application;
	
	public class AstarDemo extends Application
	{
		public function AstarDemo()
		{
			super();
			mouseChildren = true;
		}
		
		private var gridMap:Array;
		
		private var pathMap:Array;
		
		private var endP:Point;
		
		private var astar:AStar;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			astar = new AStar();

			gridMap = [];
			pathMap = [];
			
			for (var i:int = 0; i < 50; i++) 
			{
				var arr:Array = [];
				var garr:Array = [];
				gridMap.push(garr);
				pathMap.push(arr);
				for (var j:int = 0; j < 50; j++) 
				{
					var status:int = 0;
					if(i == 30 && j == 30)
					{
						endP = new Point(i, j);
						status = 3;
						arr.push(0);
					}
					else if(i == 20 && j > 10 && j < 40)
					{
						status = 2;
						arr.push(1);
					}
					else
					{
						status = 0;
						arr.push(0);
					}
					var grid:Grid = new Grid(i, j, status);
					grid.x = Grid.SIZE * i;
					grid.y = Grid.SIZE * j;
					this.addChild(grid);
					garr.push(grid);
					
				}
			}
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var grid:Grid = event.target as Grid;
			if(grid)
			{
				var arr:Array = astar.execute(this.pathMap, grid.i, grid.j, endP.x, endP.y);
				for each (var p:Point in arr) 
				{
					grid = gridMap[p.x][p.y];
					grid.status = 1;
				}
				
			}
		}
	}
}




import flash.display.Sprite;


class Grid extends Sprite
{
	
	public static const SIZE:int = 10;
	
	public var i:int;
	public var j:int;
	
	public function Grid($i:int, $j:int, $status:int = 0)
	{
		super();
		this.i = $i;
		this.j = $j;
		status = $status;
	}
	
	private var _status:int = 0;

	public function get status():int
	{
		return _status;
	}

	public function set status(value:int):void
	{
		_status = value;
		this.graphics.clear();
		
		this.graphics.lineStyle(1, 0x0);
		
		var fillColor:uint;
		switch(_status)
		{
			case 0:
				fillColor = 0xE5E5E5;
				break;
			case 1:
				fillColor = 0x63B8FF;
				break;
			case 2:
				fillColor = 0xDC143C;
				break;
			case 3:
				fillColor = 0xffff00;
				break;
		}
		this.graphics.beginFill(fillColor);
		this.graphics.drawRect(0, 0, SIZE, SIZE);
		this.graphics.endFill();
	}
}