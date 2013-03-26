package funk.actors;

import funk.Funk;
import funk.actors.Address;

using funk.actors.Address;
using funk.collections.immutable.List;

interface ActorPath {

    function address() : AddressType;

    function name() : String;

    function root() : RootActorPath;

    function parent() : ActorPath;

    function child(name : String) : ActorPath;

    function elements() : List<String>;

    function toString() : String;
}

class ActorPathName {

    public static var NameRegexp = ~/^[a-zA-Z0-9\\_]+$/;
}

class RootActorPath implements ActorPath {

    private var _address : AddressType;

    private var _name : String;

    public function new(address : AddressType, ?name : String = "/") {
        _address = address;
        _name = name;
    }

    public function address() : AddressType return _address;

    public function name() : String return _name;

    public function root() : RootActorPath return this;

    public function parent() : ActorPath return this;

    public function child(name : String) : ActorPath return new ChildActorPath(this, name);

    public function elements() : List<String> return Nil;

    public function toString() : String return _address.toString();
}

class ChildActorPath implements ActorPath {

    private var _parent : ActorPath;

    private var _name : String;

    public function new(parent : ActorPath, name : String) {
        if (name.indexOf("/") >= 0) Funk.error(ActorError("/ is a path separator and is not legal in ActorPath names"));

        _parent = parent;
        _name = name;
    }

    public function address() : AddressType return root().address();

    public function name() : String return _name;

    public function root() : RootActorPath {
        function rec(p : ActorPath) : RootActorPath {
            return switch(p) {
                case _ if(Std.is(p, RootActorPath)): cast p;
                case _: rec(p.parent());
            }
        }
        return rec(this);
    }

    public function parent() : ActorPath return _parent;

    public function child(name : String) : ActorPath return new ChildActorPath(this, name);

    public function elements() : List<String> {
        function rec(p : ActorPath, list : List<String>) {
            return switch(p) {
                case _ if(Std.is(p, RootActorPath)): list;
                case _: rec(p.parent(), list.prepend(p.name()));
            }
        }
        return rec(this, Nil);
    }

    public function toString() : String {
        function rec(p : ActorPath, buffer : StringBuffer) : StringBuffer {
            return switch(p) {
                case _ if(Std.is(p, RootActorPath)): buffer.prepend(p.toString());
                case _: rec(p.parent(), buffer.prepend("/").prepend(p.name()));
            }
        }
        return rec(this, new StringBuffer()).toString();
    }
}

// TODO (Simon) : Check if this needs optimizing.
private class StringBuffer {

    private var _buffer : List<String>;

    public function new() {
        _buffer = Nil;
    }

    public function append(value : String) : StringBuffer {
        _buffer = _buffer.append(value);
        return this;
    }

    public function prepend(value : String) : StringBuffer {
        _buffer = _buffer.prepend(value);
        return this;
    }

    public function toString() : String {
        var buf = new StringBuf();
        _buffer.foreach(function(value) buf.add(value));
        return buf.toString();
    }
}
