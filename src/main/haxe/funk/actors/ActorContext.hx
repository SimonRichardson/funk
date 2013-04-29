package funk.actors;

import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;

using funk.types.Option;
using funk.ds.immutable.List;

interface ActorContext extends ActorRefFactory {

    function start() : ActorContext;

    function stop() : ActorContext;

    function self() : InternalActorRef;

    function sender() : Option<ActorRef>;

    function children() : List<ActorRef>;

    function system() : ActorSystem;
}

class ActorContextInjector {

    private static var _contexts : List<ActorContext> = Nil;

    private static var _currentContext : Option<ActorContext> = None;

    public static function pushContext(context : ActorContext) : Void {
        _currentContext = Some(context);
        _contexts = _contexts.prepend(context);
    }

    public static function popContext() : Void {
        _contexts = _contexts.tail();
        _currentContext = _contexts.headOption();
    }

    inline public static function currentContext() : Option<ActorContext> return _currentContext;
}
