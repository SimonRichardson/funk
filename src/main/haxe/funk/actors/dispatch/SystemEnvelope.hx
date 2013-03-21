package funk.actors.dispatch;

import funk.types.AnyRef;

using funk.Funk;

enum SystemEnvelope {
    SystemEnvelope(message : AnyRef, sender : ActorRef);
}

class SystemEnvelopeTypes {

    public static function message(envelope : SystemEnvelope) : AnyRef {
        return switch (envelope) {
            case SystemEnvelope(message, _): message;
        }
    }

    public static function sender(envelope : SystemEnvelope) : ActorRef {
        return switch (envelope) {
            case SystemEnvelope(_, sender): sender;
        }
    }
}
