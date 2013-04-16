package funk.actors;

import funk.Funk;
import funk.actors.Address;

using funk.actors.Address;
using funk.types.extensions.Strings;
using funk.collections.immutable.ListUtil;
using funk.collections.immutable.List;

interface ActorPath {

    function address() : AddressType;

    function name() : String;

    function root() : RootActorPath;

    function parent() : ActorPath;

    function child(name : String) : ActorPath;

    function childs(names : List<String>) : ActorPath;

    function elements() : List<String>;

    function toString() : String;
}

class ActorPathName {

    public static var NameRegexp = ~/^[a-zA-Z0-9\\_\\-]+$/;
}

class RelativeActorPath implements ActorPath {

    private var _name : String;

    private var _names : List<String>;

    public function new(name : String = "/") {
        // This bit is a wee bit funky, essentially we want the root path if it's exists.
        var n = if (name.indexOf("/") == 0) {
            _name = "/";
            name.substr(1);
        } else name;

        var parts = n.split("/");
        _name = _name.isEmpty() ? parts.shift() : _name;
        _names = parts.toList();
    }

    public function address() : AddressType return null;

    public function name() : String return _name;

    public function root() : RootActorPath return null;

    public function parent() : ActorPath return null;

    public function child(name : String) : ActorPath return null;

    public function childs(names : List<String>) : ActorPath return null;

    public function elements() : List<String> return _names;

    public function toString() : String return _names.toString();
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

    public function childs(names : List<String>) : ActorPath {
        return if (names.isEmpty()) this;
        else child(names.head()).childs(names.tail());
    }

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

    public function childs(names : List<String>) : ActorPath {
        return if (names.isEmpty()) this;
        else child(names.head()).childs(names.tail());
    }

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

    private var _buffer : Array<String>;

    public function new() {
        _buffer = [];
    }

    public function prepend(value : String) : StringBuffer {
        _buffer.push(value);
        return this;
    }

    public function toString() : String {
        // This is done for performance reasons.
        #if (js || flash)
        var buf = "";
        var index = _buffer.length;
        while(--index>-1) {
            buf += _buffer[index];
        }
        return buf;
        #else
        var buf = new StringBuf();
        var index = _buffer.length;
        while(--index>-1) {
            buf.add(_buffer[index]);
        }
        return buf.toString();
        #end
    }
}
