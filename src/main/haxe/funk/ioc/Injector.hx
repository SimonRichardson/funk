package funk.ioc;

import funk.Funk;
import funk.collections.immutable.List;
import funk.ioc.Module;
import funk.types.Option;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

@:final
class Injector {

    private static var _map : List<Tuple2<Class<Dynamic>, IModule>> = Nil;

    private static var _scopes : List<IModule> = Nil;

    private static var _modules : List<IModule> = Nil;

    private static var _currentScope : Option<IModule> = None;

    @:noUsing
    public static function initialize(module : IModule) : IModule {
        module.initialize();

        _modules = _modules.prepend(module);

        return module;
    }

    @:noUsing
    public static function dispose(module : IModule) : IModule {
        module.dispose();

        _modules = _modules.filter(function (mod : IModule) {
            return mod == module;
        });

        return module;
    }

    @:noUsing
    public static function pushScope(module : IModule) : Void {
        _currentScope = Some(module);
        _scopes = _scopes.prepend(module);
    }

    @:noUsing
    public static function popScope() : Void {
        _scopes = _scopes.tail();
        _currentScope = _scopes.headOption();
    }

    @:noUsing
    public static function currentScope() : Option<IModule> {
        return _currentScope;
    }

    @:noUsing
    public static function scopeOf<T>(type : Class<T>) : Option<IModule> {
        var result : Option<IModule> = None;
        var modules : List<IModule> = _modules;

        while (modules.nonEmpty()) {
            var module : IModule = modules.head();

            if (module.binds(type)) {
                if (result.isDefined()) {
                    Funk.error(BindingError(Std.format("More than one module binds $type.")));
                }

                result = modules.headOption();
            }

            modules = modules.tail();
        }

        return result;
    }

    @:noUsing
    public static function moduleOf<T>(type : Class<T>) : Option<IModule> {
        var binding = _map.find(function(tuple : Tuple2<Class<Dynamic>, IModule>) : Bool {
            return Std.is(tuple._1(), tuple._2());
        });

        var possibleResult : Option<IModule> = switch(binding) {
            case None: None;
            case Some(tuple): Some(tuple._2());
        }

        if (possibleResult.isDefined()) {
            return possibleResult;
        }

        var modules : List<IModule> = _modules;

        while (modules.nonEmpty()) {
            var module : IModule = modules.head();

            if (Std.is(module, type)) {
                _map = _map.prepend(tuple2(type, module));

                return modules.headOption();
            }

            modules = modules.tail();
        }

        return None;
    }
}
