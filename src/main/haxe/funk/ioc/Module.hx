package funk.ioc;

import funk.Funk;
import funk.collections.immutable.List;
import funk.ioc.Binding;
import funk.types.extensions.Anys;
import funk.types.Function0;
import funk.types.Option;
import funk.types.Predicate2;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;
using funk.types.extensions.Reflects;
using funk.types.extensions.Tuples2;

interface IModule {

    function initialize() : Void;

    function getInstance(type : Class<Dynamic>) : Dynamic;

    function binds(type : Class<Dynamic>): Bool;

    function dispose() : Void;
}

class Module implements IModule {

    private var _map: List<Tuple2<Class<Dynamic>, Binding<Dynamic>>>;

    private var _initialized: Bool;

    public function new() {
        _map = Nil;
        _initialized = false;
    }

    public function initialize() : Void {
        configure();
        _initialized = true;
    }

    @:abstract
    public function configure() : Void {
    }

    public function getInstance(type : Class<Dynamic>) : Option<Dynamic> {
        if(!_initialized) {
            Funk.error(BindingError("Modules have to be created using \"Injector.add(new Module())\"."));
        }

        Injector.pushScope(this);

        var instance = switch(find(type)) {
            case Some(tuple): Some(tuple._2().getInstance());
            case None: None;
        }

        Injector.popScope();

        return instance;
    }

    public function binds(type : Class<Dynamic>) : Bool {
        return find(type).toBool();
    }

    public function bind(type : Class<Dynamic>) : Binding<Dynamic> {
        return bindWith(type, function () : Array<Dynamic> {
            return [];
        });
    }

    public function bindWith(type : Class<Dynamic>, func : Function0<Array<Dynamic>>) : Binding<Dynamic> {
        if(binds(type)) {
            Funk.error(BindingError(Std.format("$type is already bound.")));
        }

        var binding = new Binding(this);
        binding.to(type, func);

        _map = _map.prepend(tuple2(type, binding));

        return binding;
    }

    public function unbind(type : Class<Dynamic>) : Void {
        _map = _map.filter(function(tuple : Tuple2<Class<Dynamic>, Binding<Dynamic>>) {
            return Anys.equals(tuple._1(), type);
        });
    }

    private function find(type : Class<Dynamic>) : Option<Tuple2<Class<Dynamic>, Binding<Dynamic>>> {
        return _map.find(function(tuple : Tuple2<Class<Dynamic>, Binding<Dynamic>>) : Bool {
            return Anys.equals(tuple._1(), type);
        });
    }

    public function dispose() : Void {
        _map = Nil;
        _initialized = false;
    }
}
