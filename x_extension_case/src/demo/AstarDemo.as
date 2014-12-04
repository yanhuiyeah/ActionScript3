package demo
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import utils.AStar;
	
	import xlib.framework.Application;
	
	public class AstarDemo extends Application
	{
		public function AstarDemo()
		{
			super();
			mouseChildren = true;
		}
		
		
		
		private var astar:AStar;
		
		private var startG:Grid;
		
		private var endG:Grid;
		
		override protected function createChildren():void
		{
			super.createChildren();
			createButton();
			astar = new AStar();
			createGrids();
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var grid:Grid = event.target as Grid;
			if(grid)
			{
				grid.draw(_status);
				
				if(_status == 2)
				{
					if(this.startG)
					{
						setGrid(startG.i, startG.j, 0);
					}
					this.startG = grid;
					setGrid(grid.i, grid.j,0);
				}
				else if(_status == 3)
				{
					if(this.endG)
					{
						setGrid(endG.i, endG.j, 0);
					}
					this.endG = grid;
					setGrid(grid.i, grid.j,0);
				}
				else
				{
					setGrid(grid.i, grid.j, _status > 0 ? 1:0);
				}
					 
			}
		}
		
		
		private var grids:Dictionary = new Dictionary();
		private var path:Array = [];
		private function setGrid($i:int, $j:int, $status:int):void
		{
			path[$i][$j] = $status;
		}
		
		private function createGrids():void
		{
			for (var i:int = 0; i < 50; i++) 
			{
				var arr:Array = [];
				for (var j:int = 0; j < 50; j++) 
				{
					var f:int = Math.random() > .4?0:1;
					arr.push(f);
					var grid:Grid = new Grid(i, j);
					grid.x = Grid.SIZE * i;
					grid.y = Grid.SIZE * j;
					grid.draw(f);
					this.addChild(grid);
					grids[i + "_" + j] = grid;
				}
				path.push(arr);
			}
		}
		
		private function onSuccess($result:Array):void
		{
			for each (var p:Point in $result) 
			{
				var grid:Grid = grids[p.x + "_" +p.y];
				grid.draw(4);
			}
		}
		
		private function createButton():void
		{
			createTF("创建起点", 800, 130, 2);
			createTF("创建终点", 800, 160, 3);
			createTF("重置", 800, 190, 0);
			createTF("寻路", 800, 220, -1);
		}
		
		public var _status:int = 0;
		private function createTF($name:String, $x:int, $y:int, $status:int):TextField
		{
			var ad:AstarDemo = this;
			var tf:TextField = new TextField();
			tf.addEventListener(MouseEvent.CLICK, function($e:MouseEvent):void
			{
				ad._status = $status;
				if($status == -1)
				{
					astar.find(path, new Point(startG.i, startG.j), new Point(endG.i, endG.j), onSuccess);
					return;
				}
				
				if($status == 0)
				{
					for each (var obj:Grid in grids) 
					{
						var f:int = Math.random() > .4?0:1;
						setGrid(obj.i, obj.j, f);
						obj.draw(f);
						this.startG = null;
						this.endG = null;
					}
					return;
				}
				
			});
			tf.width = 80;
			tf.height = 24;
			tf.border = true;
			var f:TextFormat = new TextFormat();
			f.size = 12;
			f.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = f;
			tf.selectable = false;
			tf.text = $name;
			tf.x = $x;
			tf.y = $y;
			this.addChild(tf);
			return tf;
		}
		
	}
}




import flash.display.Sprite;


class Grid extends Sprite
{
	
	public static const SIZE:int = 10;
	
	public var i:int;
	public var j:int;
	
	public function Grid($i:int, $j:int)
	{
		super();
		this.i = $i;
		this.j = $j;
	}
	
	/**
	 *0普通 1障碍 2 起点 3终点 4路径 
	 * @param $type
	 * 
	 */	
	public function draw($type:uint):void
	{
		var fillColor:uint;
		var a:Number = 1;
		switch($type)
		{
			case 0:
				fillColor = 0xE5E5E5;//普通
				break;
			case 1:
				fillColor = 0xDC143C;//障碍物
				break;
			case 2:
				fillColor = 0xffff00;	//起点
				break;
			case 3:
				fillColor = 0x0000ff;	//终点
				break;
			case 4:
				fillColor = 0x000000;
				a = .6;
				break;
		}
		
		if($type < 4)
		{
			this.graphics.clear();
		}
		
		this.graphics.lineStyle(1, 0x0);
		this.graphics.beginFill(fillColor, a);
		this.graphics.drawRect(0, 0, SIZE, SIZE);
		this.graphics.endFill();
	}
}