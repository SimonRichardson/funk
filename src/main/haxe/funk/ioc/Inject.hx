package funk.ioc;

import funk.Funk;
import funk.ioc.Module;
import funk.types.Option;

using funk.types.extensions.Options;

@:final
class Inject {

    @:noUsing
    public static function as<T>(type : Class<T>) : Option<T> {
        if (null == type) {
            Funk.error(ArgumentError());
        }

        return switch(Injector.currentScope()){
            case Some(scope): scope.getInstance(type);
            case None:
                switch(Injector.scopeOf(type)) {
                    case Some(module): module.getInstance(type);
                    case None: None;
                }
        }
    }

    @:noUsing
    public static function withIn<T>(type : Class<T>, module : Class<IModule>) : Option<T> {
        if (null == type) {
            Funk.error(ArgumentError());
        }
        if (null == module) {
            Funk.error(ArgumentError());
        }

        return switch(Injector.moduleOf(module)) {
            case Some(mod): mod.getInstance(type);
            case None: None;
        }
    }
}
