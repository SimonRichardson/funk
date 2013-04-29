package funk.actors.dispatch;

import funk.types.Any;

using funk.Funk;

enum EnvelopeMessage {
    Envelope(message : AnyRef, sender : ActorRef);
    RouterEnvelope(message : AnyRef, sender : ActorRef);
    Broadcast(message : AnyRef);
}

class EnvelopeTypes {

    public static function message(envelope : EnvelopeMessage) : AnyRef {
        return switch (envelope) {
            case Envelope(message, _): message;
            case RouterEnvelope(message, _): message;
            case Broadcast(message): message;
        }
    }

    public static function sender(envelope : EnvelopeMessage) : ActorRef {
        return switch (envelope) {
            case Envelope(_, sender): sender;
            case RouterEnvelope(_, sender): sender;
            case Broadcast(_): null;
        }
    }
}
