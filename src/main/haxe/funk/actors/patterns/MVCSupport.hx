package funk.actors.patterns;

import funk.actors.Props.Creator;
import funk.types.Any;
import funk.types.extensions.EnumValues;
import funk.types.Pass;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;
import funk.actors.events.LoggingBus;
import funk.types.Function0;

using funk.types.Option;
using funk.ds.immutable.List;
using funk.types.PartialFunction1;

enum Notifications {
    AddListener(who : ActorRef);
    RemoveListener(who : ActorRef);
    SetState(what : AnyRef);
    GetState;
    TheState(from : ActorRef, state : AnyRef);
}

class Facade extends Actor {

    private var _model : ActorRef;

    private var _controller : ActorRef;

    private var _view : ActorRef;

    public function new(model : Props, view : Props, controller : Props) {
        super();

        _model = actorOf(model, "model");
        _view = actorOf(view.withCreator(new Injector(view.creator(), _model)), "view");
        _controller = actorOf(controller.withCreator(new Injector(controller.creator(), _model)), "controller");
    }

    override public function receive(value : AnyRef) : Void _controller.send(value);
}

class Model extends Actor {

    private var _state : AnyRef;

    private var _listeners : List<ActorRef>;

    public function new() {
        super();

        _listeners = Nil;
    }

    override public function receive(value : AnyRef) : Void {
        switch(value){
             case _ if(AnyTypes.isInstanceOf(value, Notifications)):
                switch(cast value) {
                    case AddListener(who): _listeners = _listeners.prepend(who);
                    case RemoveListener(who): _listeners = _listeners.filterNot(function(w) return w == who);
                    case SetState(what):
                        _state = what;
                        _listeners.foreach(function(ref) ref.send(TheState(this, _state), this));
                    case GetState:
                        var s = sender().get();
                        s.send(TheState(this, _state), s);
                    case _: // Nothing to do here.
                }
            case _:
                var system = context().system();
                system.eventStream().publish(Data(Debug, DebugMessage(  context().self().path().toString(),
                                                                        value,
                                                                        'sending to deadLetters'
                                                                        )));
                system.deadLetters().send(value);
        }
    }
}

class ProxyModelActor extends Actor {

    private var _model : ActorRef;

    public function new() {
        super();
    }

    @:allow(funk.actors.patterns)
    private function withModel(model : ActorRef) {
        if (AnyTypes.toBool(_model)) {
            _model.send(RemoveListener(this));
            _model = null;
        }

        _model = model;
        _model.send(AddListener(this));
    }

    private function model() : ActorRef return _model;
}

class View extends ProxyModelActor {

    public function new() {
        super();
    }
}

class Controller extends ProxyModelActor {

    public function new() {
        super();
    }

    // Work out if we should do this on sending or receiving
    override public function receive(value : AnyRef) : Void {
        var from = sender().getOrElse(function() return context().system().deadLetters());
        switch(value) {
            case _ if(AnyTypes.isInstanceOf(value, Notifications)):
                // Check to see if anything is coming back and forth.
                switch(cast value) {
                    case TheState(ref, val) if(ref.path().toString() != _model.path().toString()): 
                        _model.send(SetState(val), from);
                    case GetState: _model.send(GetState, from);
                    case SetState(val): _model.send(SetState(val), from);
                    case _: // Ignore.
                }
            case _: _model.send(SetState(value), from);
        } 
    }
}

class GuardedController extends Controller {

    private var _guard : PartialFunction1<AnyRef, AnyRef>;

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        if (_guard.isDefinedAt(value)) super.receive(_guard.apply(value));
        else if(AnyTypes.isInstanceOf(value, Notifications)) super.receive(value);
        else context().system().deadLetters().send(value);
    }

    @:allow(funk.actors.patterns)
    private function withGuard(guard : PartialFunction1<AnyRef, AnyRef>) : Void _guard = guard;
}

class GuardedControllerProps extends Props {

    private var _guard : PartialFunction1<AnyRef, AnyRef>;

    public function new(?controller : Class<GuardedController>) {
        super(cast (AnyTypes.toBool(controller) ? controller : GuardedController));

        _guard = Partial1(function(x) return true, function(x) return x).fromPartial();
        _creator = new GuardedCreator(_guard);
    }

    public function withGuard(guard : PartialFunction1<AnyRef, AnyRef>) : GuardedControllerProps {
        var props : GuardedControllerProps = cast clone({guard: guard});
        props._creator = new GuardedCreator(guard);
        return props;
    }

    override private function clone(overrides : AnyRef) : Props {
        var o = AnyTypes.toBool(overrides) ? overrides : {};

        var props = new GuardedControllerProps(cast _actor);
        props._router = Reflect.hasField(o, "router") ? Reflect.field(o, "router") : _router;
        props._creator = Reflect.hasField(o, "creator") ? Reflect.field(o, "creator") : _creator;
        props._dispatcher = Reflect.hasField(o, "dispatcher") ? Reflect.field(o, "dispatcher") : _dispatcher;
        props._guard = Reflect.hasField(o, "guard") ? Reflect.field(o, "guard") : _guard;
        return props;
    }
}

class FacadeCreator implements Creator {

    private var _model : Props;

    private var _view : Props;

    private var _controller : Props;

    public function new(?model : Props, ?view : Props, ?controller : Props) {
        _model = AnyTypes.toBool(model) ? model : new Props(Model);
        _view = AnyTypes.toBool(view) ? view : new Props(View);
        _controller = AnyTypes.toBool(controller) ? controller : new Props(Controller);
    }

    public function create() : Actor return Pass.instanceOf(Facade, [_model, _view, _controller])();
}

private class GuardedCreator implements Creator {

    private var _guard : PartialFunction1<AnyRef, AnyRef>;

    public function new(guard : PartialFunction1<AnyRef, AnyRef>) {
        _guard = guard;
    }

    public function create() : Actor {
        var actor : GuardedController = Pass.instanceOf(GuardedController)();
        actor.withGuard(_guard);
        return actor;
    }
}

private class Injector implements Creator {

    private var _creator : Function0<Actor>;

    private var _model : ActorRef;

    public function new(creator : Function0<Actor>, model : ActorRef) {
        _creator = creator;
        _model = model;
    }

    public function create() : Actor {
        var actor = _creator();
        if (AnyTypes.isInstanceOf(actor, ProxyModelActor)) {
            AnyTypes.asInstanceOf(actor, ProxyModelActor).withModel(_model);
        }
        return actor;
    }
}
