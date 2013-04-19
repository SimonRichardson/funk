package funk.ioc;

import funk.Funk;
import funk.types.Any;

using funk.collections.immutable.List;
using funk.ioc.Module;
using funk.types.Option;
using funk.types.Tuple2;

@:final
class Injector {

    private static var _map : List<Tuple2<Class<Dynamic>, IModule>>;

    private static var _scopes : List<IModule>;

    private static var _modules : List<IModule>;

    private static var _currentScope : Option<IModule>;

    private static var _initialized : Bool = false;

    public static function initialize() : Void {
        _initialized = true;

        _map = Nil;
        _scopes = Nil;
        _modules = Nil;
        _currentScope = None;
    }

    @:noUsing
    public static function add(module : IModule) : IModule {
        if (!_initialized) {
            return Funk.error(InjectorError("Injector.initialize() must be called first"));
        }

        _modules = _modules.prepend(module);

        module.initialize();

        return module;
    }

    @:noUsing
    public static function remove(module : IModule) : IModule {
        if (!_initialized) {
            return Funk.error(InjectorError("Injector.initialize() must be called first"));
        }

        module.dispose();

        _modules = _modules.filterNot(function(mod : IModule) {
            return mod == module;
        });

        // We have to make sure the the current scope is removed and it's not referenced in scopes.
        switch(_currentScope) {
            case Some(value): 
                if (value == module) {
                    _currentScope = None;
                }
            case None:
        }

        _scopes = _scopes.filterNot(function(mod : IModule) {
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
    public static function currentScope() : Option<IModule> return _currentScope;

    @:noUsing
    public static function scopeOf<T>(type : Class<T>) : Option<IModule> {
        if (!_initialized) {
            return Funk.error(InjectorError("Injector.initialize() must be called first"));
        }

        var result : Option<IModule> = None;
        var modules : List<IModule> = _modules;

        while (modules.nonEmpty()) {
            var module : IModule = modules.head();

            if (module.binds(type)) {
                result = modules.headOption();

                if (result.isDefined()) {
                    break;
                }
            }

            modules = modules.tail();
        }

        return result;
    }

    @:noUsing
    public static function moduleOf<T>(type : Class<T>) : Option<IModule> {
        if (!_initialized) {
            return Funk.error(InjectorError("Injector.initialize() must be called first"));
        }

        var binding = _map.find(function(tuple : Tuple2<Class<Dynamic>, IModule>) : Bool return tuple._1() == type);

        var possibleResult : Option<IModule> = switch(binding) {
            case Some(tuple): Some(tuple._2());
            case _: None;
        }

        if (possibleResult.isDefined()) {
            return possibleResult;
        }

        var modules : List<IModule> = _modules;

        while (modules.nonEmpty()) {
            var module : IModule = modules.head();

            if (AnyTypes.isInstanceOf(module, type)) {
                _map = _map.prepend(tuple2(type, module));

                return modules.headOption();
            }

            modules = modules.tail();
        }

        return None;
    }
}
