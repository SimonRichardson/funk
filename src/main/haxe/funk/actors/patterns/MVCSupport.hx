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

class Model extends Actor {

    private var _state : AnyRef;

    private var _listeners : List<ActorRef>;

    public function new() {
        super();

        _listeners = Nil;
    }

    override public function receive(value : AnyRef) : Void {
        trace(EnumValues.getEnumName(value));
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
    override public function receive(value : AnyRef) : Void {
        _model.send(SetState(value));
    }

    private function model() : ActorRef return _model;
}

class ModelCreator implements Creator {
    
    public function new(){}

    public function create() : Actor return Pass.instanceOf(Model)();
}

class ViewCreator implements Creator {

    private var _model : ActorRef;

    public function new(model : ActorRef){
        _model = model;
    }

    public function create() : Actor return Pass.instanceOf(View, [_model])();
}

class ControllerCreator implements Creator {

    private var _model : ActorRef;

    public function new(model : ActorRef){
        _model = model;
    }

    public function create() : Actor return Pass.instanceOf(Controller, [_model])();
}
