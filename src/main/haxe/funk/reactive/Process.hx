package funk.reactive;

import funk.option.Option;

import haxe.PosInfos;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

class Process {

	#if test
	dynamic
	#end
	public static function start(func : Void -> Void, time : Float) : Option<Task> {
		return if(func != null && time > 0) {
			var task = new Task(func, time);
			task.start();
			Some(task);
		} else {
			None;
		}
	}

	#if test
	dynamic
	#end
	public static function stop(task : Option<Task>) : Option<Task> {
		switch(task) {
			case Some(value):
				value.stop();
			case None:
		}
		return None;
	}

	#if test
	dynamic
	#end
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

	public var time(get_time, never) : Float;
	public var func(get_func, never) : Void -> Void;

	private var _time : Float;

	private var _run : Void -> Void;
	private var _func : Void -> Void;

	public function new(func : Void -> Void, time : Float) {
		_func = func;
		_time = time;
	}

	public function start() : Void {
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
	private function runLoop(time_ms) : Void {
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

	private function get_time() : Float {
		return _time;
	}

	private function get_func() : Void -> Void {
		return _func;
	}
}
