package funk.actors;

import funk.actors.ActorSystem;

using funk.actors.ActorCell;

class Actor {

    private var _context : ActorContext;

    private var _self : ActorRef;

    private var _sender : ActorRef;

    public function new() {
        var contextStack = ActorCell.contextStack.get();

        function noContextError() {
            Funk.Errors(ActorError("No Context Error"));
        }

        if (contextStack.isEmpty()) noContextError();
        var c = contextStack.head();
        if (AnyTypes.toBool(c)) noContextError();

        _context = c;
        _self = _context.self();
        _sender = _context.sender();

        ActorCell.contextStack.set(contextStack.push(null));
    }

    dynamic public function receive<T>(message : T) : Void {};

    public function unhandled<T>(message : T) : Void {
        switch(message) {
            // case Terminated(dead): Funk.Errors(ActorError(dead));
            case _: context().system().publish(UnhandledMessage(message, sender(), self()));
        }
    }

    public function self() : ActorRef return _self;

    public function sender() : ActorRef return _sender;

    private function context() : ActorContext return _context;
}
