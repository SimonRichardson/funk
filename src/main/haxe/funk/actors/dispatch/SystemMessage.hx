package funk.actors.dispatch;

import funk.types.AnyRef;

using funk.Funk;

enum SystemMessage {
    Create(uid : String);
    Supervise(cell : ActorRef);
    ChildTerminated(cell : ActorRef);
    Terminate;
    Watch(watchee : ActorRef, watcher : ActorRef);
    Unwatch(watchee : ActorRef, watcher : ActorRef);
}
