package funk.actors;

import funk.Funk;
import funk.actors.ActorContext;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;
using funk.collections.immutable.List;

enum ActorMessages {
    Terminated(child : ActorRef);
    UnhandledMessage(message : AnyRef, sender : Option<ActorRef>, self : ActorRef);
}

class Actor implements ActorRef {

    @:allow(funk.actors.ActorCell)
    private var _context : ActorContext;

    @:allow(funk.actors.ActorCell)
    private var _self : ActorRef;

    public function new() {
        var context = ActorContextInjector.currentContext();
        if (context.isEmpty()) Funk.error(ActorError("No Context Error"));

        _context = context.get();
        _self = _context.self();
    }

    public function preStart() : Void {}

    public function postStop() : Void {}

    public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {
        _context.children().foreach(function(child) child.context().stop());
        postStop();
    }

    public function postRestart(reason : Errors) : Void preStart();

    public function receive(message : AnyRef) : Void unhandled(message);

    public function actorOf(props : Props, name : String) : ActorRef return _self.actorOf(props, name);

    public function actorFor(path : ActorPath) : Option<ActorRef> return _self.actorFor(path);

    public function send(value : AnyRef, ?sender : ActorRef = null) : Void _self.send(value, sender);

    public function stop() : Void _context.stop();

    public function path() : ActorPath return _self.path();

    public function name() : String return path().name();

    public function sender() : Option<ActorRef> return _context.sender();

    public function context() : ActorContext return _context;

    public function isTerminated() : Bool return _self.isTerminated();

    private function unhandled(message : AnyRef) : Void {
        // handle termination
        switch(message) {
            case _ : context().system().eventStream().publish(UnhandledMessage(message, sender(), _self));
        }
    }

    public function toString() return '[Actor (path=${path().toString()})]';
}
