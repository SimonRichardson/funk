package funk.ioc;

import funk.Funk;
import funk.types.Function0;
import haxe.ds.Option;
import funk.types.Provider;

using funk.types.extensions.Bools;
using funk.types.extensions.Reflects;

enum BindingType<T> {
    To(type : Class<T>, func : Function0<Array<Dynamic>>);
    Instance(instance : T);
    Provider(provider : Class<Provider<T>>);
}

@:final
class Binding<T> {

    private var _module : Module;

    private var _bindingType : BindingType<T>;

    private var _singletonScope : Bool;

    private var _evaluated : Bool;

    private var _value : T;

    public function new(module : Module) {
        if (null == module) {
            Funk.error(ArgumentError());
        }

        _module = module;

        _evaluated = false;
        _singletonScope = false;
    }

    public function to(type : Class<T>, ?func : Function0<Array<Dynamic>>) : Scope {
        if (null == type) {
            Funk.error(ArgumentError());
        }

        if (null == func) {
            func = function () {
                return [];
            };
        }

        _evaluated = false;
        _bindingType = To(type, func);
        return this;
    }

    public function toInstance(instance : T) : Scope {
        if (null == instance) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = Instance(instance);
        return this;
    }

    public function toProvider(provider : Class<Provider<T>>) : Scope {
        if (null == provider) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = Provider(provider);
        return this;
    }

    public function getInstance() : T {
        return if(_singletonScope) {
            if(!_evaluated) {
                _value = solve();
                _evaluated = true;
            }

            // Passes back the instance.
            _value;
        } else {
            solve();
        }
    }

    public function asSingleton() : Void {
        _singletonScope = true;
    }

    private function solve() : T {
        return switch(_bindingType) {
            case To(type, func): Reflects.createInstance(type, func());
            case Instance(instance): instance;
            case Provider(provider): Reflects.createEmptyInstance(provider).get();
        }
    }
}
