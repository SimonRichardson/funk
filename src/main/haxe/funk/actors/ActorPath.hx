package funk.actors;

class ActorPath {

    private var _address : Address;

    public function new(address : Address) {
        _address = address;
    }

    public function root() : RootActorPath {
        return new RootActorPath(_address.host());
    }

    public function parent() : ActorPath {
        return new ActorPath(_address.uri());
    }

    public function name() : String {
        return _address.path();
    }
}
