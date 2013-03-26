package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.actors.Props;
import funk.futures.Deferred;
import funk.types.AnyRef;
import funk.types.Attempt;

using funk.futures.Promise;

class AskSupport {

    private static var UniqueId(get_UniqueId, never) : Int;

    private static var _uniqueId : Int = 0;

    private static function get_UniqueId() : Int return _uniqueId++;

    public static function ask( actor : ActorRef,
                                value : AnyRef,
                                sender : ActorRef) : Promise<AnyRef> {
        var deferred = new Deferred();
        var promise = deferred.promise();

        var system = actor.context().system();
        var name = '${actor.name()}_promise_${UniqueId}';
        var creator = new AskSupportRefCreator(deferred);
        var askRef = system.actorOf(new Props().withCreator(creator), name);

        actor.send(value, askRef);

        return promise;
    }
}

private class AskSupportRef extends Actor {

    private var _deferred : Deferred<AnyRef>;

    public function new(deferred : Deferred<AnyRef>) {
        super();

        _deferred = deferred;
    }

    override public function recieve(value : AnyRef) : Void {
        switch(Type.typeof(value)) {
            case TEnum(e) if(e == Attempt || e == AttemptType):
                var attempt : Attempt<AnyRef> = cast value;
                switch(value){
                    case Success(v): _deferred.resolve(v);
                    case Failure(e): _deferred.reject(e);
                    case _: _deferred.resolve(value);
                }
            case _: _deferred.resolve(value);
        }
    }
}

private class AskSupportRefCreator implements Creator {

    private var _deferred : Deferred<AnyRef>;

    public function new(deferred : Deferred<AnyRef>) {
        _deferred = deferred;
    }

    public function create() : Actor return Pass.instanceOf(AskSupportRef, [_deferred])();
}

