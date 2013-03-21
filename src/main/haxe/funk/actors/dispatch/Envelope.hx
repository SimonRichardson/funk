package funk.actors.dispatch;

using funk.Funk;

enum EnvelopeMessage<T> {
    Envelope(message : T, sender : ActorRef);
}

class EnvelopeTypes {

    public static function message<T>(envelope : EnvelopeMessage<T>) : T {
        return switch (envelope) {
            case Envelope(message, _): message;
        }
    }

    public static function sender<T>(envelope : EnvelopeMessage<T>) : ActorRef {
        return switch (envelope) {
            case Envelope(_, sender): sender;
        }
    }
}
