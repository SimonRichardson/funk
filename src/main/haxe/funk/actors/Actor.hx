package funk.actors;

import funk.Funk;
import funk.actors.ActorContext;
import funk.actors.SupervisorStrategy;
import funk.types.Any;
import funk.types.PartialFunction1;

using funk.futures.Promise;
using funk.types.Option;
using funk.ds.immutable.List;

enum ActorMessages {
    Failed(cause : Dynamic, uid : String);
    Terminated(child : ActorRef);
    Kill;
    PoisonPill;
    SelectParent(message : AnyRef);
    UnhandledMessage(message : AnyRef, sender : Option<ActorRef>, self : ActorRef);
}

typedef Receive = PartialFunction1<AnyRef, Void>;

class Actor implements ActorRef {

    public static var emptyBehaviour : Receive = PartialFunction1Types.fromPartial(Partial1(function(x) return false, 
                                                                                            function(x) return Funk.error(IllegalOperationError("Empty behavior apply()"))
                                                                                            ));

    @:allow(funk.actors.ActorCell)
    private var _context : ActorContext;

    @:allow(funk.actors.ActorCell)
    private var _self : ActorRef;

    private var _supervisorStrategy : SupervisorStrategy;

    public function new() {
        var context = ActorContextInjector.currentContext();
        if (context.isEmpty()) Funk.error(ActorError("No Context Error"));

        _context = context.get();
        _self = _context.self();

        _supervisorStrategy = new OneForOneStrategy();
    }

    public function preStart() : Void {}

    public function postStop() : Void {}

    public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {
        _context.children().foreach(function(child) child.context().stop());
        postStop();
    }

    public function postRestart(reason : Errors) : Void preStart();

    public function receive(message : AnyRef) : Void unhandled(message);

    inline public function actorOf(props : Props, name : String) : ActorRef return _self.actorOf(props, name);

    inline public function actorFor(path : ActorPath) : Option<ActorRef> return _self.actorFor(path);

    inline public function send(value : AnyRef, ?sender : ActorRef = null) : Void _self.send(value, sender);

    inline public function stop() : Void _context.stop();

    inline public function path() : ActorPath return _self.path();

    inline public function uid() : String return _self.uid();

    inline public function name() : String return path().name();

    inline public function sender() : Option<ActorRef> return _context.sender();

    inline public function context() : ActorContext return _context;

    inline public function supervisorStrategy() : SupervisorStrategy return _supervisorStrategy;

    inline public function isTerminated() : Bool return _self.isTerminated();

    @:allow(funk.actors.ActorCell)
    private function unhandled(message : AnyRef) : Void {
        // handle termination
        switch(message) {
            case _ : context().system().eventStream().publish(UnhandledMessage(message, sender(), _self));
        }
    }

    public function toString() return '[Actor (path=${path().toString()})]';
}
