package funk.reactive;

import funk.option.Option;

import haxe.PosInfos;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

class Process {

	public static function start(func : Void -> Void, time : Float) : Option<Task> {
		return if(func != null && time > 0) {
			Some(new Task(func, time));
		} else {
			None;
		}
	}

	public static function stop(task : Option<Task>) : Option<Task> {
		switch(task) {
			case Some(value):
				value.stop();
			case None:
		}
		return None;
	}

	public static function stamp() : Float {
		return Date.now().getTime();
	}
}

class Task {

	#if (neko||cpp)
		private var id:Thread;
	#else
		private var id:Null<Int>;
	#end

	private var _time : Float;

	private var _run : Void -> Void;
	private var _func : Void -> Void;

	public function new(func : Void -> Void, time : Float) {
		_func = func;
		_time = time;

		_run = function() {
			stop();
			_func();
		};

		var time_ms = Std.int(time);
		var scope = this;
		#if flash9
			id = untyped __global__["flash.utils.setInterval"](function() { scope._run(); }, time_ms);
		#elseif flash
			id = untyped _global["setInterval"](function() { scope._run(); }, time_ms);
		#elseif js
			id = untyped window.setInterval(function() { scope._run(); }, time_ms);
		#elseif (neko||cpp)
			id = Thread.create(function() { scope.runLoop(time_ms); } );
		#end
	}	

	public function stop() : Void {
		if (id == null) {
			return;
		}
		
		_run = function() {
		};

		#if flash9
			untyped __global__["flash.utils.clearInterval"](id);
		#elseif flash
			untyped _global["clearInterval"](id);
		#elseif js
			untyped window.clearInterval(id);
		#elseif (neko||cpp)
			id.sendMessage("stop");
		#end

		#if (flash || js)
		id = null;
		#end
	}

	#if (neko||cpp)
	private function runLoop(time_ms) {
		var shouldStop = false;
		while(!shouldStop) {
			Sys.sleep(time_ms/1000);
			try {
				_run();
			} catch(ex:Dynamic) {
			}

			var msg = Thread.readMessage(false);
			if (msg == "stop") {
				shouldStop = true;
			}
		}
	}
	#end
}