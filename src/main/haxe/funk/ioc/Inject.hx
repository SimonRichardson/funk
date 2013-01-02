package funk.ioc;

import funk.Funk;
import funk.ioc.Module;

@:final
class Inject {

    @:noUsing
    public static function as<T>(type : Class<T>) : T {
        if (null == type) {
            Funk.error(ArgumentError());
        }

        return switch(Injector.currentScope()){
            case Some(scope): scope.getInstance(type);
            case None:
                switch(Injector.scopeOf(type)) {
                    case Some(module): module.getInstance(type);
                    case None: Funk.error(BindingError(Std.format("No binding for $type could be found.")));
                }
        }
    }

    @:noUsing
    public static function withIn<T>(type : Class<T>, module : Class<IModule>) : T {
        if (null == type) {
            Funk.error(ArgumentError());
        }
        if (null == module) {
            Funk.error(ArgumentError());
        }

        return switch(Injector.moduleOf(module)) {
            case Some(mod): mod.getInstance(type);
            case None: Funk.error(BindingError(Std.format("No module for $type could be found.")));
        }
    }
}
