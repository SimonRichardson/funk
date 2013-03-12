package funk.actors;

class ActorRef {

    public function new() {

    }

    public function ask<T>(reciever : ActorRef, message : T) : Future<T> {

    }

    public function path() : ActorPath {
        return null;
    }

    public function forward<T>(message : T) : Void {

    }

    public function tell<T>(message : T, sender : ActorRef) : Void {
        // var ref = AnyTypes.toBool(sender) ? sender : system.deadLetters;
        // dispatcher.dispatch(this, Envelope(message, s)(system))
    }
}