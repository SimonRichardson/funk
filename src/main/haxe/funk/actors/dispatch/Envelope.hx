package funk.actors.dispatch;

using funk.Funk;

enum Envelope {
    Envelope(message : EnumValue, sender : ActorRef);
}

class EnvelopeTypes {

    public static function message(envelope : Envelope) : EnumValue {
        return switch (envelope) {
            case Envelope(message, _): message;
        }
    }

    public static function sender(envelope : Envelope) : ActorRef {
        return switch (envelope) {
            case Envelope(_, sender): sender;
        }
    }
}
