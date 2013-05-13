package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.reactives.Stream;
import funk.types.Any;

using funk.types.Option;
using funk.ds.immutable.List;
using funk.types.PartialFunction1;

class ReactSupport {

    public static function react(actor : ActorRef, ?bubble : Bool = true) : Stream<AnyRef> {
        var local : LocalActorRef = AnyTypes.asInstanceOf(actor, LocalActorRef);
        var underlying : ActorCell = local.underlying();

        // Create a partial that calls each one
        var stream = StreamTypes.identity(None);
        var streamPartial = Partial1(function(x) return true, function(value) return stream.dispatch(value));
        var actorPartial = Partial1(function(x) return true, function(value) return underlying.actor().receive(value));

        // Merge the partials
        var partials = PartialFunction1Types.fromPartials(Nil.append(streamPartial).append(actorPartial));

        // Make a new partial
        var partial = Partial1(function(x) return true, function(value) {
            return partials.applyToAll(value).last().getOrElse(function() return null);
        }).fromPartial();

        // Become
        underlying.become(partial);

        return stream;
    }
}
