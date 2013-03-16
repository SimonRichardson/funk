package funk.actors;

using funk.actors.ActorCell;
using funk.actors.ActorSystem;
using funk.futures.Promise;
using funk.types.Option;

class ActorRef {

    private var _actorCell : ActorCell;

    private var _actorContext : ActorContext;

    public function new() {
        _actorCell = new ActorCell(_system, this, _props);
        _actorContext = _actorCell;
    }

    public function ask<T>(reciever : ActorRef, message : T) : Promise<T> {
        return null;
    }

    public function path() : ActorPath {
        return null;
    }

    public function forward<T>(message : T) : Void {

    }

    public function tell<T>(message : T, sender : ActorRef) : Void {
        // var ref = AnyTypes.toBool(sender) ? sender : system.deadLetters;
        // dispatcher.dispatch(this, Envelope(message, s)(system))
    }

    public function suspended() : Void _actorCell.suspended();

    public function resume() : Void _actorCell.resume();

    public function stop() : Void _actorCell.stop();

    public function parent() : ActorRef return _actorCell.parent();

    public function provider() return _actorCell.provider();

    public function getChild(names : List<String>) : ActorRef {
        function rec(ref : ActorRef, name : List<String>) : ActorRef {
            return switch(ref) {
                case _ if(Std.is(ref, InternalActorRef)):
                    var n = names.head();
                    var next = switch(n) {
                        case "..": ref.parent().toOption();
                        case "": Some(ref);
                        case _: ref.getSingleChild(n).toOption();
                    }
                    if (next.isDefined() || name.isEmpty()) next;
                    else rec(next, name.tail());
                case _: ref.getChild(name);
            }
        }

        return if (names.isEmpty()) this;
        else rec(this, names);
    }

    private function getSingleChild(name : String) : Option<InternalActorRef> {
        _actorCell.childrenRefs.filter(function(value) {
            return value.name() == name;
        });
    }
}
