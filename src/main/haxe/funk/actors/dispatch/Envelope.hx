package funk.actors.dispatch;

using funk.Funk;

enum EnvelopeMessage {
    Envelope(message : EnumValue, sender : ActorRef);
}

class EnvelopeTypes {

    public static function message(envelope : EnvelopeMessage) : EnumValue {
        return switch (envelope) {
            case Envelope(message, _): message;
        }
    }

    public static function sender(envelope : EnvelopeMessage) : ActorRef {
        return switch (envelope) {
            case Envelope(_, sender): sender;
        }
    }
}
