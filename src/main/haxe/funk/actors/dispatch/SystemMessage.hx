package funk.actors.dispatch;

import funk.types.Any;

using funk.Funk;

enum SystemMessage {
    NullMessage;
    Create(uid : String);
    Supervise(cell : ActorRef, async : Bool, uid : String);
    ChildTerminated(cell : ActorRef);
    Recreate(cause : Dynamic);
    Resume(causedByFailure : Dynamic);
    Suspend;
    Terminate;
    Watch(watchee : ActorRef, watcher : ActorRef);
    Unwatch(watchee : ActorRef, watcher : ActorRef);
}
