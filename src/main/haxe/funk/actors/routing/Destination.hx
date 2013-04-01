package funk.actors.routing;

import funk.types.AnyRef;

using funk.Funk;

enum Destination {
    Destination(sender: ActorRef, recipient: ActorRef);
}

class DestinationTypes {

    public static function sender(destination : Destination) : ActorRef {
        return switch (destination) {
            case Destination(sender, _): sender;
        }
    }

    public static function recipient(destination : Destination) : ActorRef {
        return switch (destination) {
            case Destination(_, recipient): recipient;
        }
    }
}
