package funk.actors;

import funk.actors.dispatch.Dispatchers;
import funk.Funk;
import funk.actors.routing.Routing;
import funk.types.Any;
import funk.types.Function0;
import funk.types.Pass;

interface Creator {
    function create() : Actor;
}

class Props {

    private var _actor : Class<Actor>;

    private var _router : RouterConfig;

    private var _creator : Creator;

    private var _dispatcher : String;

    public function new(?actor : Class<Actor> = null) {
        _actor = actor;
        _router = new NoRouter();
        _creator = new CreatorImpl(actor);
        _dispatcher = Dispatchers.DefaultDispatcherId;
    }

    public function create(actor : Actor) : Props {
        return new Props().withCreator(new SingletonCreatorImpl(actor));
    }

    public function creator() : Function0<Actor> return _creator.create;

    public function dispatcher() : String return _dispatcher;

    public function router() : RouterConfig return _router;

    public function withCreator<T>(creator : Creator) : Props return clone({creator: creator});

    public function withDispatcher(dispatcher : String) : Props return clone({dispatcher: dispatcher});

    public function withRouter(router : RouterConfig) : Props return clone({router: router});

    private function clone(overrides : AnyRef) : Props {
        var o = AnyTypes.toBool(overrides) ? overrides : {};

        var props = new Props();
        props._router = Reflect.hasField(o, "router") ? Reflect.field(o, "router") : _router;
        props._creator = Reflect.hasField(o, "creator") ? Reflect.field(o, "creator") : _creator;
        props._dispatcher = Reflect.hasField(o, "dispatcher") ? Reflect.field(o, "dispatcher") : _dispatcher;
        return props;
    }

    public function toString() return '[Props (router=${router().toString()})]';
}

private class CreatorImpl implements Creator {

    private var _actor : Class<Actor>;

    public function new(?actor : Class<Actor> = null) {
        _actor = actor;
    }

    public function create() : Actor {
        return if (AnyTypes.toBool(_actor)) Pass.instanceOf(_actor)();
        else Funk.error(ActorError("Actor instance passed to Props can't be 'null'"));
    }
}

private class SingletonCreatorImpl implements Creator {

    private var _actor : Actor;

    public function new(actor : Actor) {
        _actor = actor;
    }

    public function create() : Actor return _actor;
}
