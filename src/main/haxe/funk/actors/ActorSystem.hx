package funk.actors;

class ActorSystem {

    private var _actors : List<Actors>;

    public function new() {
        _actors = Nil;
    }

    public function actorOf(props : Props, name : String) : ActorRef {
        
        return null;
    }

    public function name() : String {
        return null;
    }

    public function scheduler() : Scheduler {
        return null;
    }
}
