package xlib.framework.manager
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import xlib.framework.core.Global;
	import xlib.framework.core.LazyDispatcher;
	import xlib.framework.events.TickEvent;
	
	/**
	 *计时器 代替flash的timer 
	 * 单利类 不能被实例化 请使用instance
	 * @author yeah
	 */	
	public class TickManager extends LazyDispatcher
	{
		
		/**
		 *根据持续时间调用 (不管时间差内应该执行几次,都最多只执行一次)
		 * @param $handler		函数
		 * @param $delay			延时-毫秒
		 * @param $repeat		循环次数 -1无限循环
		 * @param $param		函数参数
		 * @param $executeNow		是否立即执行
		 * @return 
		 */		
		public function doDuration($handler:Function, $delay:int, $repeat:int = -1, $param:Array=null , $executeNow:Boolean = false):Object
		{
			return create($handler, $delay, false, $repeat, $param, false, $executeNow);
		}
		
		
		/**
		 *根据持续时间调用 (时间差内应该执行几次,就执行几次, 除非循环结束--repeat == 0)
		 * @param $handler		函数
		 * @param $delay			延时-毫秒
		 * @param $repeat		循环次数 -1无限循环
		 * @param $param		函数参数
		 * @param $executeNow		是否立即执行
		 * @return 
		 */		
		public function doReviseDuration($handler:Function, $delay:int, $repeat:int = -1, $param:Array=null , $executeNow:Boolean = false):Object
		{
			return create($handler, $delay,true  , $repeat, $param, false, $executeNow);
		}
		
		/**
		 *根据帧数调用 (不管帧数差内应该执行几次,都最多只执行一次)
		 * @param $handler		函数
		 * @param $delay			延时-帧
		 * @param $repeat		循环次数 -1无限循环
		 * @param $param		函数参数
		 * @param $executeNow		是否立即执行
		 * @return 
		 */		
		public function doFrame($handler:Function, $delay:int, $repeat:int = -1, $param:Array=null , $executeNow:Boolean = false):Object
		{
			return create($handler, $delay, false, $repeat, $param, true, $executeNow);
		}
		
		
		/**
		 *根据帧数调用  (帧数差内应该执行几次,就执行几次, 除非循环结束--repeat == 0)
		 * @param $handler		函数
		 * @param $delay			延时-帧
		 * @param $repeat		循环次数 -1无限循环
		 * @param $param		函数参数
		 * @param $executeNow		是否立即执行
		 * @return 
		 */		
		public function doReviseFrame($handler:Function, $delay:int, $repeat:int = -1, $param:Array=null , $executeNow:Boolean = false):Object
		{
			return create($handler, $delay,true, $repeat, $param, true, $executeNow);
		}
		
		/**
		 *清除 
		 * @param $handler    在执行列表中的方法
		 * $key==null 则清楚所有
		 */		
		public function clean($handler:Function = null):void
		{
			var handler:XTimerHandler;
			if($handler == null)
			{
				for(var key:Object in handlers)
				{
					recycle(handler[key]);
				}
			}
			else if($handler in handlers)
			{
				handler = handlers[$handler];
				recycle(handler);
			}
		}
		
		/**
		 *回收
		 * @param $handler XTimerHandler
		 */		
		private function recycle($handler:XTimerHandler):void
		{
			if(!$handler) return;
			delete handlers[$handler.handler];
			$handler.reset();
			PoolStorage.instance.push($handler, xTimerHandlerKey);
			handlersLength--;
			
			if(handlersLength <= 0)
			{
				handlersLength = 0;
			}
		}
		
		/**
		 *创建 
		 * @param $handler			函数
		 * @param $delay				延时 $useFrame = true 帧 $useFrame = false 毫秒
		 * @param revise				如果计算结果>1是否重复执行(比如:delay = 10毫秒,每次onEnterFrame 经过100毫秒,结算结果应该是100/10 = 10; true:执行10次 false 执行1次)
		 * @param $repeat			循环次数 -1无限循环
		 * @param $param			函数参数
		 * @param $useFrame		使用帧还是timer
		 * @param $executeNow	是否立即执行
		 * @return 
		 */		
		private function create($handler:Function, $delay:int, $revise:Boolean, $repeat:int = -1, $param:Array=null ,$useFrame:Boolean = false, $executeNow:Boolean = false):Object
		{
			var handler:XTimerHandler;
			
			if($handler in handlers)
			{
				handler = handlers[$handler];
			}
			else
			{
				handler = PoolStorage.instance.pop(this.xTimerHandlerKey) as XTimerHandler;
				if(!handler)
				{
					handler = new XTimerHandler();
				}
				
				handler.handler = $handler;
				handlers[$handler] = handler;
				handlersLength++;
			}
			
			handler.param = $param;
			handler.delay = $delay;
			handler.repeat = $repeat;
			handler.useFrame = $useFrame;
			handler.revise = $revise;
			handler.passed = 0;
			
			if($executeNow)
			{
				handler.execute(handler.delay);
				if(handler.repeat == 0)
				{
					recycle(handler);
				}
			}
			
			return handlersLength;
		}
		
		/**
		 *函数字典 
		 */		
		private var handlers:Dictionary;
		
		/**
		 *执行列表长度
		 */		
		private var handlersLength:int = 0;
		
		/**
		 *执行列表长度
		 * @return 
		 */		
		public function getLength():int
		{
			return handlersLength;
		}
		
		//===================tick========================
		/***FrameTickEvent最大时间间隔（防止待机后返回卡死）*/		
		public static const MAX_INTERVAL:int = 3000;
		
		/***帧率*/		
		public function get frameRate():int
		{
			return Global.instance.stage.frameRate;
		}
		
		/**
		 *暂停 
		 */		
		public function pause():void
		{
			tick.pause();
		}
		
		private var _rate:Number = 1.0;
		/***速度比率*/		
		public function get rate():Number
		{
			return tick.rate;
		}
		
		public function set rate(value:Number):void
		{
			tick.rate = value;
		}
		
		/**
		 *每帧调用 
		 * @param $e
		 */		
		private function onTick($e:TickEvent):void
		{
			if(handlersLength < 1) return;
			
			for each(var handler:XTimerHandler in handlers)
			{
				handler.execute(handler.useFrame ? 1 : tick.interval);
				if(handler.repeat == 0)
				{
					recycle(handler);
				}
			}
		}
		
		//======================================================
		/**
		 *创建tick 
		 * @param $rate	变速器
		 * @return 
		 */		
		public function createTick($rate:Number = 1.0):Tick
		{
			var t:Tick = new Tick(shape);
			t.rate = $rate;
			return t;
		}
		//======================================================
		
		/**
		 *shape 
		 */		
		private var shape:Shape;
		
		/**
		 *tick 
		 */		
		private var tick:Tick;
		
		/**
		 * XTimerHandler的完全限定名
		 */		
		private var xTimerHandlerKey:String;
		
		/**
		 * XTimer  唯一实例
		 */		
		public static function get instance():TickManager
		{
			if(!_instance)
			{
				_instance = new TickManager(new XTimerHandler());
			}
			return _instance;
		}
		private static var _instance:TickManager;

		/**
		 *单利类 不能被实例化 请使用XTimer.instance
		 * @param $inexistentClass
		 */		
		public function TickManager($inexistentClass:XTimerHandler)
		{
			shape = new Shape();
			super(shape);
			handlers = new Dictionary();
			xTimerHandlerKey = getQualifiedClassName(XTimerHandler);
			tick = createTick();
			tick.addEventListener(TickEvent.FRAME_TICK, onTick);
		}
	}
}


/**
 *计时器调用函数VO
 * @author yeah
 */
class XTimerHandler
{
	/**
	 *true 使用enterFrame  false 使用timer
	 */	
	public var useFrame:Boolean = false;
	
	/**
	 *已经进过的 
	 */	
	public var passed:int;
	
	/**
	 * useFrame=true: 	帧间隔
	 * useFrame=false:	时间间隔(毫秒)
	 */	
	public var delay:int;
	
	/**
	 *循环次数(-1为无限循环) 
	 */	
	public var repeat:int = -1;
	
	/**
	 *定时调用的方法 
	 */	
	public var handler:Function;
	
	/**
	 *参数 
	 */	
	public var param:Array;
	
	/**
	 *是否修正
	 * true 根据计算得出的执行次数 进行多次执行
	 * false 不管应该经过多少次 只执行一次
	 * 比如:delay = 10毫秒		每次onEnterFrame 经过100毫秒  结算结果应该是100/10 = 10; true:执行10次 false 执行1次
	 */	
	public var revise:Boolean = false;
	
	/**
	 *重置
	 */	
	public function reset():void
	{
		handler = null;
		param = null;
		passed = 0;
	}
	
	/**
	 *执行
	 * @param $addtion 增量
	 */	
	public function execute($addtion:int):void
	{
		passed += $addtion;
		if(passed < delay) return;
				
		if(revise)
		{
			var times:int = passed/delay;
			while(times > 0)
			{
				handler.apply(null, param);
				times--;
				if(repeat != -1)
				{
					repeat--;
					if(repeat == 0)
					{
						break;
					}
				}
			}
			passed %= delay;
		}
		else
		{
			handler.apply(null, param);
			repeat--;
			passed = 0;
		}
		
		if(repeat == 0)
		{
			reset();
		}
	}
	
	public function XTimerHandler()
	{
	}
}