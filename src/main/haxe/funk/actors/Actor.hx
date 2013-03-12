package funk.actors;

import funk.actors.ActorContext;

class Actor {

    private var _context : ActorContext;

    public function new() {
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
