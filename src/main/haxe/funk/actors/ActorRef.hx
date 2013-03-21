package funk.actors;

import funk.Funk;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;

interface ActorRef {

    function name() : String;

    function path() : ActorPath;

    function ask(msg : AnyRef, sender : ActorRef) : Promise<AnyRef>;

    function send(msg : AnyRef, sender : ActorRef) : Void;

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(name : String) : ActorRef;
}