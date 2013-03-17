package funk.actors;

using funk.actors.routing.Routing;
using funk.types.Function1;

typedef Creator = {
    create: Function1<Void, Actor>
};

class Props {

    private var _router : Router;

    private var _creator : Creator;

    private var _dispatcher : String;

    public function new(actor : Class<Actor>) {
        _creator = {
            function() {
                return actor();
            }
        };
        _dispatcher = "default-dispatcher";
        _router = new NoRouter();
    }

    public function creator() : Function1<Void, Actor> return _creator.create;

    public function dispatcher() : String return _dispatcher;

    public function router() : Router return _router;

    public function withCreator<T>(creator : Creator) : Props {
        var props = new Props();
        props._router = _router;
        props._creator = creator;
        props._dispatcher = _dispatcher;
        return props;
    }

    public function withDispatcher(dispatcher : String) : Props {
        var props = new Props();
        props._router = _router;
        props._creator = _creator;
        props._dispatcher = dispatcher;
        return props;
    }

    public function withRouter(router : Router) : Props {
        var props = new Props();
        props._router = router;
        props._creator = _creator;
        props._dispatcher = _dispatcher;
        return props;
    }
}
