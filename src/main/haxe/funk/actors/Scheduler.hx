package funk.actors;

import funk.futures.Deferred;
import funk.futures.Promise;
import funk.reactives.Process;
import funk.types.Function0;

using funk.actors.ActorRef;
using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.List;

typedef Cancellable = {

    function cancel() : Void;

    function isCancelled() : Bool;
}

interface Runnable {

    function run() : Void;
}

interface Scheduler {

    function schedule(  initialDelay : Float,
                        interval : Float,
                        reciever : ActorRef,
                        message : AnyRef
                        ) : Cancellable;

    function scheduleRunner(initialDelay : Float, interval : Float, runner : Runnable) : Cancellable;

    function scheduleOnce(  initialDelay : Float,
                            interval : Float,
                            reciever : ActorRef,
                            message : AnyRef
                            ) : Cancellable;

    function scheduleRunnerOnce(initialDelay : Float, interval : Float, runner : Runnable) : Cancellable;

    function close() : Void;
}

class DefaultScheduler implements Scheduler {

    private var _timers : List<DefaultTimer>;

    public function new() {
        _timers = Nil;
    }

    public function schedule(   initialDelay : Float,
                                interval : Float,
                                reciever : ActorRef,
                                message : AnyRef
                                ) : Cancellable {
        return scheduleRunner(initialDelay, interval, new Runner(function() {
            reciever.send(message);
            if (reciever.isTerminated()) {
                // Something is not quite right
            }
        }));
    }

    public function scheduleOnce(   initialDelay : Float,
                                    interval : Float,
                                    reciever : ActorRef,
                                    message : AnyRef
                                    ) : Cancellable {
        return scheduleRunnerOnce(initialDelay, interval, new Runner(function() {
            reciever.send(message);
            if (reciever.isTerminated()) {
                // Something is not quite right
            }
        }));
    }

    public function close() : Void {
        _timers.foreach(function(timer) {
            cancel(timer);
            execute(timer);
        });
    }

    public function scheduleRunner(initialDelay : Float, interval : Float, runnable : Runnable) : Cancellable {
        var hasInterval = interval > 0;

        return if (hasInterval) {
            var timer = new DefaultTimer(initialDelay, interval, runnable);
            timer.promise().then(function(timer){
                _timers = _timers.filterNot(function(value) return value == timer);
            });

            _timers = _timers.prepend(timer);
            timer.start();
        } else {
            Funk.error(ActorError("Invalid time interval for continuous execution"));
        }
    }

    public function scheduleRunnerOnce(initialDelay : Float, interval : Float, runnable : Runnable) : Cancellable {
        var hasInterval = interval > 0;
        var hasInitalDelay = initialDelay > 0;

        // If we inline this we get a massive speed upgrade.
        return if (hasInterval && hasInitalDelay) {
            var timer = new DefaultTimer(initialDelay, interval, runnable, true);
            timer.promise().then(function(timer){
                _timers = _timers.filterNot(function(value) return value == timer);
            });

            _timers = _timers.prepend(timer);
            timer.start();
        } else {
            runnable.run();
            null;
        }
    }

    private function cancel(timer : DefaultTimer) : Void {
        try timer.cancel() catch(e : Dynamic) {
            // TODO (Simon) : Log out the error
            throw e;
        }
    }

    private function execute(timer : DefaultTimer) : Void {
        try timer.runnable().run() catch(e : Dynamic) {
            // TODO (Simon) : Log out the error
            throw e;
        }
    }
}

private class DefaultTimer {

    private var _task : Option<Task>;

    private var _once : Bool;

    private var _runnable : Runnable;

    private var _deferred : Deferred<DefaultTimer>;

    private var _initialDelay : Float;

    private var _interval : Float;

    public function new(initialDelay : Float, interval : Float, runnable : Runnable, ?once : Bool = false) {
        _runnable = runnable;
        _once = once;

        _deferred = new Deferred();
    }

    public function start() : DefaultTimer {
        var hasInterval = _interval > 0;
        var hasInitalDelay = _initialDelay > 0;

        function callable0() {
            // Execute it without delay or interval
            if (_once) _runnable.run();
            else Funk.error(ActorError("Invalid time interval for continuous execution"));

            _deferred.resolve(this);
        }

        function callable1() {
            _runnable.run();

            if (_once) {
                task().stop();
                _deferred.resolve(this);
            }
        }

        _task = if (!hasInterval && !hasInitalDelay) { callable0(); None; }
        else if (!hasInterval && hasInitalDelay) Process.start(function() callable0(), _initialDelay);
        else if (hasInterval && !hasInitalDelay) Process.start(function() callable1(), _interval);
        else Process.start(function() _task = Process.start(function() callable1(), _interval), _initialDelay);

        return this;
    }

    public function task() : Task return _task.getOrElse(function() {
        return Funk.error(ActorError("No valid task"));
    });

    public function runnable() : Runnable return _runnable;

    public function cancel() : Void {
        task().stop();

        _deferred.resolve(this);
    }

    public function isCancelled() : Bool return task().isCancelled();

    public function promise() : Promise<DefaultTimer> return _deferred.promise();
}

private class Runner implements Runnable {

    private var _func : Function0<Void>;

    public function new(func : Function0<Void>) {
        _func = func;
    }

    public function run() _func();
}
