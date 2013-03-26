package funk.actors;

import funk.Funk;
import funk.actors.ActorContext;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;
using funk.collections.immutable.List;

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

    public function receive(value : AnyRef) : Void {}

    public function actorOf(props : Props, name : String) : ActorRef return _self.actorOf(props, name);

    public function actorFor(name : String) : Option<ActorRef> return _self.actorFor(name);

    public function send(value : AnyRef, sender : ActorRef) : Void _self.send(value, sender);

    public function path() : ActorPath return _self.path();

    public function name() : String return path().name();

    public function sender() : Option<ActorRef> return _context.sender();

    public function context() : ActorContext return _context;
}
