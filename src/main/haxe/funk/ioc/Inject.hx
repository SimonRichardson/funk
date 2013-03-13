package funk.ioc;

import funk.Funk;

using funk.ioc.Module;
using funk.types.Option;
using funk.types.Any;
using funk.types.extensions.Bools;

@:final
class Inject {

    @:noUsing
    public static function as<T>(type : Class<T>) : Option<T> {
        if (type.toBool().not()) Funk.error(ArgumentError());

        return switch(Injector.currentScope()){
            case Some(scope):
                var instance = scope.getInstance(type);
                switch (instance) {
                    case Some(_): instance;
                    case None: with(type);
                };
            case _: with(type);
        };
    }

    @:noUsing
    public static function with<T>(type : Class<T>) : Option<T> {
        if (type.toBool().not()) Funk.error(ArgumentError());

        return switch(Injector.scopeOf(type)) {
            case Some(module): module.getInstance(type);
            case _: None;
        };
    }

    @:noUsing
    public static function withIn<T>(type : Class<T>, module : Class<IModule>) : Option<T> {
        if (type.toBool().not()) Funk.error(ArgumentError());
        if (module.toBool().not()) Funk.error(ArgumentError());

        return switch(Injector.moduleOf(module)) {
            case Some(mod): mod.getInstance(type);
            case _: None;
        }
    }
}
