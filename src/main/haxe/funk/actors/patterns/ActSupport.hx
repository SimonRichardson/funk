package funk.actors.patterns;

import funk.actors.Props;
import funk.types.AnyRef;
import funk.types.Function1;
import funk.types.Pass;

class ActSupport {

    public static function actor(system : ActorSystem, name : String) : Function1<Act, ActorRef> {
        return function(act : Act) : ActorRef {
            return system.actorOf(new Props().withCreator(new ActCreator(act)), name);
        };
    }
}

class Act {

    private var _receiver : Function1<AnyRef, Void>;

    public function new(receiver : Function1<AnyRef, Void>) {
        _receiver = receiver;
    }    

    public function receiver() : Function1<AnyRef, Void> return _receiver;
}

private class ActActor extends Actor {

    private var _receiver : Function1<AnyRef, Void>;

    public function new(receiver : Function1<AnyRef, Void>) {
        super();

        _receiver = receiver;
    }

    override public function receive(value : AnyRef) : Void _receiver(value);
}

private class ActCreator implements Creator {

    private var _act : Act;

    public function new(act : Act) {
        _act = act;
    }

    public function create() : Actor return Pass.instanceOf(ActActor, [_act.receiver()])();
}
