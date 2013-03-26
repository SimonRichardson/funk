package funk.actors.dispatch;

import funk.types.AnyRef;
import funk.types.Option;

using funk.Funk;

enum DeadLetterMessage {
    DeadLetter(message : AnyRef, origin : Option<ActorRef>, reciever : Option<ActorRef>);
}
