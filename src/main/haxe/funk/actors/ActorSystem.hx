package funk.actors;

import funk.actors.ActorPath;
import funk.actors.Address;

using funk.actors.ActorRef;
using funk.futures.Promise;
using funk.collections.immutable.List;
using funk.types.Any;
using funk.types.Option;
using funk.types.Lazy;

class ActorSystem {

    private var _name : String;

    private var _isTerminated : Bool;

    private var _rootActor : ActorRef;

    private var _rootActorPath : ActorPath;

    private var _guardianActor : ActorRef;

    private var _guardianActorPath : ActorPath;

    private var _systemActor : ActorRef;

    private var _systemActorPath : ActorPath;

    function new(name : String) {
        _name = name;

        _isTerminated = false;

        _rootActorPath = new RootActorPath(Address("funk", name, None, None));
        _rootActor = new InternalActorRef(_rootActorPath);

        _guardianActorPath = _rootActorPath.child("guardian");
        _systemActorPath = _rootActorPath.child("sys");

        trace(_guardianActorPath.child("fuckshitup").toString());

        _guardianActor = new InternalActorRef(_guardianActorPath);
        _systemActor = new InternalActorRef(_systemActorPath);
    }

    public static function create(name : String) : ActorSystem {
        return new ActorSystem(name);
    }

    public function actorOf(props : Props, name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function actorFor(name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function start() : Void {
        
    }

    public function actorPath() : ActorPath return _rootActorPath;

    public function child(name : String) : ActorPath return _rootActorPath.child(name);

    public function name() : String return _name;
}
