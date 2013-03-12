package funk.actors;

import funk.actors.ActorContext;

class Actor {

    private var _context : ActorContext;

    private var _self : ActorRef;

    public function new() {
        var contextStack = ActorCell.contextStack.get();

        function noContextError() {
            Funk.Errors(ActorError("No Context Error"));
        }

        if (contextStack.isEmpty()) noContextError();
        var c = contextStack.head();
        if (AnyTypes.toBool(c)) noContextError();

        _context = c;
        _self = _context;
    }

    public function recieve<T>(message : T) : Void {
        return null;
    }

    public function self() : ActorRef {
        return null;
    }

    public function sender() : ActorRef {
        return null;
    }

    private function context() : ActorContext {
        return _context;
    }
}
