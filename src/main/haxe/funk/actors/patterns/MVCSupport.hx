package funk.actors.patterns;

import funk.actors.Props.Creator;
import funk.types.AnyRef;
import funk.types.extensions.EnumValues;
import funk.types.Pass;

using funk.types.Option;
using funk.collections.immutable.List;

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
        _view = actorOf(view.withCreator(new Injector(view.actor(), _model)), "view");
        _controller = actorOf(controller.withCreator(new Injector(controller.actor(), _model)), "controller");
    }

    override public function receive(value : AnyRef) : Void _controller.send(value, sender().get());
}

class Model extends Actor {

    private var _state : AnyRef;

    private var _listeners : List<ActorRef>;

    public function new() {
        super();

        _listeners = Nil;
    }

    override public function receive(value : AnyRef) : Void {
        switch(Type.typeof(value)){
            case TEnum(e) if(e == Notifications):
                var note : Notifications = cast value;
                switch(note) {
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
            case _: context().system().deadLetters().send(value);
        }
    }
}

class View extends Actor {

    private var _model : ActorRef;

    public function new(model : ActorRef) {
        super();

        _model = model;
        _model.send(AddListener(this));
    }

    override public function receive(value : AnyRef) : Void {

    }

    private function model() : ActorRef return _model;
}

class Controller extends Actor {

    private var _model : ActorRef;

    public function new(model : ActorRef) {
        super();

        _model = model;
    }

    // Work out if we should do this on sending or receiving
    override public function receive(value : AnyRef) : Void _model.send(SetState(value));

    private function model() : ActorRef return _model;
}

class FacadeCreator implements Creator {

    private var _model : Props;

    private var _view : Props;

    private var _controller : Props;

    public function new(model : Props, view : Props, controller : Props) {
        _model = model;
        _view = view;
        _controller = controller;
    }

    public function create() : Actor return Pass.instanceOf(Facade, [_model, _view, _controller])();
}

private class Injector implements Creator {

    private var _type : Class<Actor>;

    private var _model : ActorRef;

    public function new(type : Class<Actor>, model : ActorRef) {
        _type = type;
        _model = model;
    }

    public function create() : Actor return Pass.instanceOf(_type, [_model])();
}
