package funk.actors;

import funk.actors.ActorPath;
import funk.actors.ActorRefProvider;
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

    function new(name : String, refProvider : ActorRefProvider) {
        _name = name;

        _isTerminated = false;
        _provider = refProvider;
    }

    public static function create(name : String, ?refProvider : ActorRefProvider) : ActorSystem {
        var provider = AnyTypes.toBool(refProvider) ? refProvider : new LocalActorRefProvider();
        var system = new ActorSystem(name, provider);
        return system.start();
    }

    public function actorOf(props : Props, name : String) : Promise<ActorRef> {
        var guard = _provider.guardian();
        return guard.ask(CreateChild(props, name), guard).map(function(value : AnyRef) return cast value);
    }

    public function actorFor(name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function start() : ActorSystem {
        _provider.init(this);
        return this;
    }

    public function actorPath() : ActorPath return _provider.rootPath();

    public function child(name : String) : ActorPath return actorPath().child(name);

    public function name() : String return _name;
}
