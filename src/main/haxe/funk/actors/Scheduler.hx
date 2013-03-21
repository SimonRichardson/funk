package funk.actors;

using funk.actors.ActorRef;
using funk.types.AnyRef;

typedef Cancellable = {

    function cancel() : Void;

    function isCancelled() : Bool;
}

interface Runnable {

    function run() : Void;
}

interface Scheduler {

    function schedule(reciever : ActorRef, message : AnyRef) : Cancellable;

    function scheduleOnce(reciever : InternalActorRef, message : AnyRef) : Cancellable;

    function close() : Void;
}
