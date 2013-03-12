package funk.actors;

typedef ActorPath = {

    function address() : Address;

    function name() : String;

    function root() : RootActorPath;

    function parent() : ActorPath;

    function child(child : String) : ActorPath;

    function elements() : List<String>;
}

class RootActorPath extends ActorPath {

    private var _address : Address;

    private var _name : String;

    public function new(address : Address, ?name : String = "/") {
        _address = address;
        _name = name;
    }

    public function address() : Address return _address;

    public function name() : String return _name;

    public function root() : RootActorPath return this;

    public function parent() : ActorPath return this;

    public function child(child : String) : ActorPath return new ChildActorPath(this, child);

    public function elements() : List<String> return Nil;
}

class ChildActorPath {

    private var _parent : ActorPath;

    private var _name : String;

    public function new(parent : ActorPath, name : String) {
        if (name.indexOf("/") < 0) Funk.Errors("/ is a path separator and is not legal in ActorPath names");

        _parent = parent;
        _name = name;
    }

    public function address() : Address return _root.address();

    public function name() : String return _name;

    public function root() : RootActorPath {
        function rec(p : ActorPath) {
            return switch(p) {
                case _ if(Std.is(p, RootActorPath)): p;
                case _: rec(p.parent());
            }
        }
        return rec(this);
    }

    public function parent() : ActorPath return _parent;

    public function child(child : String) : ActorPath return new ChildActorPath(this, child);

    public function elements() : List<String> {
        function rec(p : ActorPath, list : List<String>) {
            return switch(p) {
                case _ if(Std.is(p, RootActorPath)): list;
                case _: rec(p.parent(), list.prepend(p.name()));
            }
        }
        return rec(this, Nil);
    }
}
