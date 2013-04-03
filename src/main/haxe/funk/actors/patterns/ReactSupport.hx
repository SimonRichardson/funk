package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.reactives.Stream;
import funk.types.AnyRef;

using funk.types.Option;

class ReactSupport {

    public static function react(actor : ActorRef, ?bubble : Bool = true) : Stream<AnyRef> {
        if (!Std.is(actor, LocalActorRef)) {
            Funk.error(IllegalOperationError('Expected a LocalActorRef'));
        }

        var stream = StreamTypes.identity(None);

        var local : LocalActorRef = cast actor;
        local.underlying().become(function(value : AnyRef) {
            stream.dispatch(value);
            return bubble;
        });

        return stream;
    }
}
