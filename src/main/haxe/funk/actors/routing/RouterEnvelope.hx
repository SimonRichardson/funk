package funk.actors.routing;

import funk.types.AnyRef;

using funk.Funk;

enum RouterEnvelope {
    RouterEnvelope(message : AnyRef, sender : ActorRef);
    Broadcast(message : AnyRef);
}

class RouterEnvelopeTypes {

    public static function message(envelope : RouterEnvelope) : AnyRef {
        return switch (envelope) {
            case RouterEnvelope(message, _): message;
            case Broadcast(message): message;
        }
    }
}
