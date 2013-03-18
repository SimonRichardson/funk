package funk.actors;

import funk.Funk;
import funk.actors.ActorSystem;

using funk.actors.ActorCell;
using funk.types.AnyRef;
using funk.types.Option;

class Actor {

    private var _context : ActorContext;

    private var _self : ActorRef;

    private var _sender : ActorRef;

    public function new() {
        var context = ActorContextInjector.currentContext();
        if (context.isEmpty()) Funk.error(ActorError("No Context Error"));

        _context = context.get();
        _self = _context.self();
        _sender = _context.sender();
    }

    public function preStart() : Void {}

    public function postStop() : Void {}

    public function receive(message : EnumValue) : Void {}

    public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {
        context.children().foreach(function(value) value.stop());
        postStop();
    }

    public function postRestart(reason : Errors) : Void preStart();

    public function unhandled(message : EnumValue) : Void {
        switch(message) {
            case Terminated(dead): Funk.Errors(ActorError(dead));
            case _: context().system().publish(UnhandledMessage(message, sender(), self()));
        }
    }

    public function self() : ActorRef return _self;

    public function sender() : ActorRef return _sender;

    private function context() : ActorContext return _context;

    // TODO (Simon) : Add behaviours
}
