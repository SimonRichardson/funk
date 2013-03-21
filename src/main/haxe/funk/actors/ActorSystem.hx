package funk.actors;

import funk.actors.ActorPath;
import funk.actors.ActorRefProvider;

using funk.actors.ActorRef;
using funk.futures.Promise;
using funk.collections.immutable.List;
using funk.types.Any;
using funk.types.Option;
using funk.types.Lazy;

class ActorSystem {

    private var _name : String;

    private var _isTerminated : Bool;

    private var _refProvider : ActorRefProvider;

    function new(name : String, refProvider : ActorRefProvider) {
        _name = name;

        _isTerminated = false;
        _refProvider = refProvider;
    }

    public static function create(name : String, ?refProvider : ActorRefProvider) : ActorSystem {
        var provider = AnyTypes.toBool(refProvider) ? refProvider : new LocalActorRefProvider(name);
        return new ActorSystem(name, provider);
    }

    public function actorOf(props : Props, name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function actorFor(name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function start() : Void {

    }

    public function actorPath() : ActorPath return _refProvider.rootPath();

    public function child(name : String) : ActorPath return actorPath().child(name);

    public function name() : String return _name;
}
