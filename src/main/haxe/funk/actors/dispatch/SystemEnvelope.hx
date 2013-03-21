package funk.actors.dispatch;

using funk.Funk;

enum SystemEnvelope<T> {
    SystemEnvelope(message : T, sender : ActorRef);
}

class SystemEnvelopeTypes {

    public static function message<T>(envelope : SystemEnvelope<T>) : T {
        return switch (envelope) {
            case SystemEnvelope(message, _): message;
        }
    }

    public static function sender<T>(envelope : SystemEnvelope<T>) : ActorRef {
        return switch (envelope) {
            case SystemEnvelope(_, sender): sender;
        }
    }
}
