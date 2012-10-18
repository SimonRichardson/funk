package funk.reactive.utils;

import haxe.PosInfos;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

// TODO (Simon) : We should have one thread and use the delta to call the functions.
class Timer {

	#if (neko||cpp)
		private var id:Thread;
	#else
		private var id:Null<Int>;
	#end

	public function new(time_ms:Int) {
		var scope = this;
		#if flash9
			id = untyped __global__["flash.utils.setInterval"](function() { scope.run(); },time_ms);
		#elseif flash
			id = untyped _global["setInterval"](function() { scope.run(); },time_ms);
		#elseif js
			id = untyped window.setInterval(function() { scope.run(); },time_ms);
		#elseif (neko||cpp)
			id = Thread.create(function() { scope.runLoop(time_ms); } );
		#end
	}

	public function stop() {
		if (id == null) {
			return;
		}
		
		#if flash9
			untyped __global__["flash.utils.clearInterval"](id);
		#elseif flash
			untyped _global["clearInterval"](id);
		#elseif js
			untyped window.clearInterval(id);
		#elseif (neko||cpp)
			run = function() {};
			id.sendMessage("stop");
		#end

		#if (flash9||flash||js)
		id = null;
		#end
	}

	public dynamic function run() {

	}

	#if (neko||cpp)
	private function runLoop(time_ms) {
		var shouldStop = false;
		while(!shouldStop) {
			Sys.sleep(time_ms/1000);
			try {
				run();
			} catch(ex:Dynamic) {
				trace(ex);
			}

			var msg = Thread.readMessage(false);
			if (msg == "stop") shouldStop = true;
		}
	}
	#end

	public static function delay(func:Void -> Void, time_ms:Int):Timer {
		var timer = new Timer(time_ms);
		timer.run = function() {
			timer.stop();
			func();
		};
		return timer;
	}

	public static function measure<T>(func : Void -> T, ?pos : PosInfos) : T {
		var t0 = stamp();
		var r = func();
		trace((stamp() - t0) + "s", pos);
		return r;
	}

	/**
	 *	Returns a timestamp, in seconds
	 */
	public static function stamp():Float {
		#if flash
			return flash.Lib.getTimer() / 1000;
		#elseif (neko||cpp)
			return Sys.time();
		#elseif js
			return Date.now().getTime() / 1000;
		#else
			return 0;
		#end
	}
}