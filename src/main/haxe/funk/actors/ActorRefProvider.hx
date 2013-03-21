package funk.actors;

import funk.Funk;
import funk.actors.ActorPath;
import funk.actors.ActorRef;

using funk.types.Option;

interface ActorRefProvider {

    function rootPath() : ActorPath;

}

class LocalActorRefProvider implements ActorRefProvider {

    private var _rootActor : ActorRef;

    private var _guardianActor : ActorRef;

    private var _systemActor : ActorRef;

    public function new(systemName : String) {

        var rootActorPath = new RootActorPath(Address("funk", systemName, None, None));
        var guardianActorPath = rootActorPath.child("guardian");
        var systemActorPath = rootActorPath.child("sys");

        _rootActor = new InternalActorRef(rootActorPath);
        _guardianActor = new InternalActorRef(guardianActorPath);
        _systemActor = new InternalActorRef(systemActorPath);
    }

    public function rootPath() : ActorPath return _rootActor.path();
}
