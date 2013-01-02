package funk.ioc;

import funk.Funk;
import funk.collections.immutable.List;
import funk.types.Option;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

interface IModule {

    function initialize(): Void;

    function getInstance(type: Class<Dynamic>): Dynamic;

    function binds(type: Class<Dynamic>): Bool;
}

class Module implements IModule {

    private var _map: List<Tuple2<Class<Dynamic>, Binding<Dynamic>>>;
    private var _initialized: Bool;

    public function new() {
        _map = Nil;
        _initialized = false;
    }

    @:final
    public function initialize(): Void {
        configure();
        _initialized = true;
    }

    @:abstract
    public function configure(): Void {
    }

    @:final
    public function getInstance(type: Class<Dynamic>)  : Option<Dynamic> {
        if(!_initialized) {
            Funk.error(BindingError("Modules have to be created using \"Injector.initialize(new Module())\"."));
        }

        var binding = _map.find(function(tuple : Tuple2<Class<Dynamic>, Binding<Dynamic>>) : Bool {
            return Std.is(tuple._1(), tuple._2());
        });

        try {
            Injector.pushScope(this);

            var instance = switch(binding) {
                case None: Type.createInstance(type, []);
                case Some(tuple): tuple._2().getInstance();
            }

            Injector.popScope();

            return Some(instance);
        } catch(error : Dynamic) {
            Injector.popScope();
        }

        return None;
    }

    @:final
    public function binds(type: Class<Dynamic>): Bool {
        var binding = _map.find(function(tuple : Tuple2<Class<Dynamic>, Binding<Dynamic>>) : Bool {
            return Std.is(tuple._1(), tuple._2());
        });
        return switch(binding) {
            case None: false;
            case Some(tuple): true;
        }
    }

    private function bind(type: Class<Dynamic>): Binding<Dynamic> {
        if(binds(type)) {
            Funk.error(BindingError(Std.format("$type is already bound.")));
        }

        var binding = new Binding(this, type);

        _map = _map.prepend(tuple2(type, binding));

        return binding;
    }
}
