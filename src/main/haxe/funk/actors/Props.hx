package funk.actors;

import funk.Funk;

using funk.actors.routing.Routing;
using funk.types.Any;
using funk.types.AnyRef;
using funk.types.Function0;
using funk.types.Pass;

typedef Creator = {
    create: Function0<Actor>
};

class Props {

    private var _router : Router;

    private var _creator : Creator;

    private var _dispatcher : String;

    public function new(?actor : Class<Actor> = null) {
        _creator = {
            create: function() : Actor {
                return if (AnyTypes.toBool(actor)) Pass.instanceOf(actor)();
                else Funk.error(ActorError("Actor instance passed to Props can't be 'null'"));
            }
        };
        _dispatcher = "default-dispatcher";
        _router = new NoRouter();
    }

    public function creator() : Function0<Actor> return _creator.create;

    public function dispatcher() : String return _dispatcher;

    public function router() : Router return _router;

    public function withCreator<T>(creator : Creator) : Props {
        return clone({creator: creator});
    }

    public function withDispatcher(dispatcher : String) : Props {
        return clone({dispatcher: dispatcher});
    }

    public function withRouter(router : Router) : Props {
        return clone({router: router});
    }

    private function clone(overrides : AnyRef) : Props {
        var o = !AnyTypes.toBool(overrides) ? overrides : {};

        var props = new Props();
        props._router = Reflect.hasField(o, "router") ? Reflect.field(o, "router") : _router;
        props._creator = Reflect.hasField(o, "creator") ? Reflect.field(o, "creator") : _creator;
        props._dispatcher = Reflect.hasField(o, "dispatcher") ? Reflect.field(o, "dispatcher") : _dispatcher;
        return props;
    }
}
