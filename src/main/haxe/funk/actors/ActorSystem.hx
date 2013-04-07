package funk.actors;

import funk.actors.ActorPath;
import funk.actors.ActorRefProvider;
import funk.actors.dispatch.Dispatchers;
import funk.actors.events.EventStream;
import funk.actors.Scheduler;
import funk.types.AnyRef;

using funk.actors.ActorRef;
using funk.collections.immutable.List;
using funk.types.Any;
using funk.types.Option;
using funk.futures.Promise;
using funk.types.Lazy;

class ActorSystem {

    private var _name : String;

    private var _isTerminated : Bool;

    private var _provider : ActorRefProvider;

    private var _dispatchers : Dispatchers;

    private var _scheduler : Scheduler;

    function new(name : String, refProvider : ActorRefProvider) {
        _name = name;

        _isTerminated = false;
        _provider = refProvider;

        _scheduler = new DefaultScheduler();
        _dispatchers = new Dispatchers(this);
    }

    public static function create(name : String, ?refProvider : ActorRefProvider) : ActorSystem {
        var provider = AnyTypes.toBool(refProvider) ? refProvider : new LocalActorRefProvider();
        var system = new ActorSystem(name, provider);
        return system.start();
    }

    public function actorOf(props : Props, name : String) : ActorRef {
        return _provider.guardian().context().actorOf(props, name);
    }

    public function actorFor(path : ActorPath) : Option<ActorRef> return _provider.guardian().context().actorFor(path);

    public function start() : ActorSystem {
        _provider.init(this);
        return this;
    }

    public function actorPath() : ActorPath return _provider.rootPath();

    public function child(name : String) : ActorPath return actorPath().child(name);

    public function name() : String return _name;

    public function deadLetters() : ActorRef return _provider.deadLetters();

    public function dispatchers() : Dispatchers return _dispatchers;

    public function eventStream() : EventStream return _provider.eventStream();

    public function settings() : Settings return _provider.settings();

    public function scheduler() : Scheduler return _scheduler;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _provider;

    @:allow(funk.actors)
    @:allow(funk.actors.events)
    private function systemActorOf(props : Props, name : String) : ActorRef {
        var systemGuardian = _provider.systemGuardian();
        return if (AnyTypes.isInstanceOf(systemGuardian, LocalActorRef)) {
            var local : LocalActorRef = cast systemGuardian;
            local.underlying().attachChild(props, name);
        } else {
            Funk.error(IllegalOperationError());
        }
    }

    public function toString() return '[ActorSystem]';
}
