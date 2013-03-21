package funk.actors.dispatch;

using funk.Funk;

enum Envelope<T> {
    Envelope(message : T, sender : ActorRef);
}

class EnvelopeTypes {

    public static function message<T>(envelope : Envelope<T>) : T {
        return switch (envelope) {
            case Envelope(message, _): message;
        }
    }

    public static function sender<T>(envelope : Envelope<T>) : ActorRef {
        return switch (envelope) {
            case Envelope(_, sender): sender;
        }
    }
}
