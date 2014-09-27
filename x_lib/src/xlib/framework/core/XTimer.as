package xlib.framework.core
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 *计时器 代替flash的timer 
	 * 单利类 不能被实例化 请使用XTimer.instance
	 * @author yeah
	 */	
	public class XTimer
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
				unRegister();
			}
		}
		
		/**
		 *是否修正
		 * true 根据计算得出的执行次数 进行多次执行
		 * false 不管应该经过多少次 只执行一次
		 * 比如:delay = 10毫秒		每次onEnterFrame 经过100毫秒  结算结果应该是100/10 = 10; true:执行10次 false 执行1次
		 */	
		
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
			register();
			
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
			handler.passed = $useFrame ? frameCount : getTimer();
			
			if($executeNow)
			{
				handler.execute();
			}
			
			return handlersLength;
		}
		
		//======================================================
		
		/**
		 * enterFrame事件的接收者
		 */		
		private var frameShape:Shape;
		
		/**
		 *函数字典 
		 */		
		private var handlers:Dictionary;
		
		/**
		 *当前世间getTiemr(); 
		 */		
		private var passedTimer:int;
		
		/**
		 *经过的总帧数 
		 */		
		private var frameCount:int;
		
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

		/**
		 *每帧调用 
		 * @param $e
		 */		
		private function onEnterFrame($e:Event):void
		{
			frameCount++;
			passedTimer = getTimer();
			
			var criterionValue:int;
			for each(var handler:XTimerHandler in handlers)
			{
				criterionValue = handler.useFrame ? frameCount:passedTimer;
				if(criterionValue > handler.passed)
				{
					if(handler.revise)
					{
						while(criterionValue > handler.passed)
						{
							handler.execute();
						}
					}
					else
					{
						handler.execute();
					}
					
					if(handler.repeat == 0)
					{
						recycle(handler);
						break;
					}
				}
			}
		}
		
		/**
		 *是否注册过 
		 */		
		private var isRegister:Boolean = false;
		
		/**
		 *注册 
		 */		
		private function register():void
		{
			if(isRegister) return;
			frameShape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			isRegister = true;
		}
		
		
		/**
		 *解除 
		 */		
		private function unRegister():void
		{
			if(!isRegister) return;
			frameShape.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			isRegister = false;
		}
		
		//======================================================
		
		/**
		 * XTimerHandler的完全限定名
		 */		
		private var xTimerHandlerKey:String;
		
		/**
		 * XTimer  唯一实例
		 */		
		public static function get instance():XTimer
		{
			if(!_instance)
			{
				_instance = new XTimer(new XTimerHandler());
			}
			return _instance;
		}
		private static var _instance:XTimer;

		/**
		 *单利类 不能被实例化 请使用XTimer.instance
		 * @param $inexistentClass
		 */		
		public function XTimer($inexistentClass:XTimerHandler)
		{
			frameShape = new Shape();
			handlers = new Dictionary();
			xTimerHandlerKey = getQualifiedClassName(XTimerHandler);
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
	 * useFrame=true: 	帧间隔
	 * useFrame=false:	时间间隔(毫秒)
	 */	
	public var delay:int;
	
	/**
	 * useFrame=true: 	经过的帧
	 * useFrame=false:	经过的时间(毫秒)
	 */	
	public var passed:int;
	
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
	}
	
	/**
	 *执行 
	 */	
	public function execute():void
	{
		passed += delay;
		if(repeat != -1 && repeat > 0)
		{
			repeat--;
		}
		if(handler == null || repeat == 0) return;
		handler.apply(null, param);
	}
	
	public function XTimerHandler()
	{
	}
}