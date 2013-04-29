package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.actors.Props;
import funk.futures.Deferred;
import funk.types.Any;
import funk.types.Function1;
import funk.types.Pass;

#if js
import js.Browser;
import js.html.Blob;
import js.html.Worker;
#end

using funk.futures.Promise;

class WorkerActorSupport {

    private static var UniqueId(get_UniqueId, never) : Int;

    private static var _uniqueId : Int = 0;

    private static function get_UniqueId() : Int return _uniqueId++;

    public static function parallel(    actor : ActorRef,
                                        func : Function1<AnyRef, AnyRef>,
                                        value : AnyRef
                                        ) : Promise<AnyRef> {
        var deferred = new Deferred();
        var promise = deferred.promise();

        #if js
        var system = actor.context().system();
        var name = '${actor.name()}_parallel_${UniqueId}';
        var creator = new WorkerActorSupportCreator(deferred, func);
        var workerRef = system.actorOf(new Props().withCreator(creator), name);

        workerRef.send(value, actor);
        #else
        deferred.resolve(func(value));
        #end

        return promise;
    }
}

#if js
private class WorkerActorSupportRef extends Actor {

    private var _deferred : Deferred<AnyRef>;

    private var _func : Function1<AnyRef, Void>;

    private var _url : String;

    public function new(    deferred : Deferred<AnyRef>,
                            func : Function1<AnyRef, Void>
                            ) {
        super();

        _deferred = deferred;
        _func = func;


        var origin = untyped __js__('func.valueOf()');
        var code = '
        function callable(args) {
            var func = ${origin};
            if (typeof func === "function") {
                return func.apply(this, [args]);
            }
        }
        onmessage = function(e) {
            postMessage(callable(e.data));
            close();
        };
        ';

        var blob = new Blob([code], {
            type: 'text/javascript'
        });

        var URL = untyped __js__('window.URL || window.webkitURL || window.mozURL || window.msURL || window.oURL');
        _url = URL.createObjectURL(blob);
    }

    override public function receive(value : AnyRef) : Void {
        var url = this._url;
        var worker = untyped __js__('new Worker(url)');
        worker.onmessage = function(e) {
            var data = e.data;

            if (AnyTypes.toBool(data)) _deferred.resolve(data);
            else _deferred.reject(Error('Result is null'));
        };

        worker.postMessage(value);
    }
}

private class WorkerActorSupportCreator implements Creator {

    private var _deferred : Deferred<AnyRef>;

    private var _func : Function1<AnyRef, Void>;

    public function new(    deferred : Deferred<AnyRef>,
                            func : Function1<AnyRef, Void>
                            ) {
        _deferred = deferred;
        _func = func;
    }

    public function create() : Actor {
        return Pass.instanceOf(WorkerActorSupportRef, [_deferred, _func])();
    }
}

#end
