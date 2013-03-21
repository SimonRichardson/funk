package funk.actors;

using funk.actors.ActorRef;
using funk.futures.Promise;
using funk.collections.immutable.List;
using funk.types.Any;
using funk.types.Lazy;

class ActorSystem {

    private var _name : String;

    private var _isTerminated : Bool;

    function new(name : String) {
        _name = name;

        _isTerminated = false;
    }

    public static function create(name : String) : ActorSystem {
        return new ActorSystem(name);
    }

    public function child(name : String) : ActorPath {
        return null;
    } 

    public function actorOf(props : Props, name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function actorFor(name : String) : Promise<ActorRef> {
        return PromiseTypes.empty();
    }

    public function start() : Void {
        
    }

    public function name() : String {
        return _name;
    }
}
