package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.reactives.Stream;
import funk.types.Any;

using funk.types.Option;
using funk.types.PartialFunction1;

class ReactSupport {

    public static function react(actor : ActorRef, ?bubble : Bool = true) : Stream<AnyRef> {
        if (!AnyTypes.isInstanceOf(actor, LocalActorRef)) {
            Funk.error(IllegalOperationError('Expected a LocalActorRef'));
        }

        var stream = StreamTypes.identity(None);

        var local : LocalActorRef = cast actor;

        var partial = Partial1(function(x) return true, function(value : AnyRef) {
            stream.dispatch(value);
            return local.underlying().actor().receive(value);
        });
        local.underlying().become(partial.fromPartial());

        return stream;
    }
}
