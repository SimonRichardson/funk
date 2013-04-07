package funk.reactives;

import funk.Funk;
import funk.types.Function0;
import funk.types.Option;
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
    public static function start(func : Function0<Void>, time : Float) : Option<Task> {
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
    public var func(get_func, never) : Function0<Void>;

    private var _time : Float;

    private var _run : Function0<Void>;
    private var _func : Function0<Void>;

    private var _isCancelled : Bool;

    public function new(func : Function0<Void>, time : Float) {
        _func = func;
        _time = time;

        _isCancelled = false;
    }

    public function start() : Void {
        _run = function() {
            stop();
            _func();
        };

        // Note (Simon) : Should use externs for this.
        var scope = this;
        #if flash9
            id = untyped __global__["flash.utils.setInterval"](function() scope._run(), time);
        #elseif js
            id = untyped __js__("setInterval")(function() scope._run(), time);
            //id = js.Browser.window.setInterval(function() scope._run(), Std.int(time));
        #elseif (neko || cpp)
            id = Thread.create(function() scope.runLoop(Std.int(time)));
        #end
    }

    public function stop() : Void {
        if (id == null) {
            return;
        }

        _isCancelled = true;

        _run = function() {
        };

        // Note (Simon) : Should use externs for this.
        #if flash9
            untyped __global__["flash.utils.clearInterval"](id);
        #elseif js
            untyped __js__("clearInterval")(id);
        #elseif (neko || cpp)
            id.sendMessage("stop");
        #end

        #if (flash || js)
        id = null;
        #end
    }

    public function isCancelled() : Bool return _isCancelled;

    #if (neko||cpp)
    private function runLoop(time_ms) : Void {
        var shouldStop = false;
        while (!shouldStop) {
            Sys.sleep(time_ms / 1000);
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

    private function get_time() : Float return _time;

    private function get_func() : Function0<Void> return _func;
}
