package funk.ioc;

import funk.Funk;
import funk.types.Function0;
import funk.types.Option;
import funk.types.Provider;

using funk.types.extensions.Bools;
using funk.types.extensions.Reflects;

enum BindingType<T> {
    To(type : Class<T>, func : Function0<Array<Dynamic>>);
    Instance(instance : T);
    Provider(provider : Class<Provider<T>>);
}

@:final
class Binding<T1, T2> {

    public var boundTo(get_boundTo, set_boundTo) : T2;

    private var _module : Module;

    private var _boundTo : T2;

    private var _bindingType : BindingType<T1>;

    private var _singletonScope : Bool;

    private var _evaluated : Bool;

    private var _value : T1;

    public function new(module : Module) {
        if (null == module) {
            Funk.error(ArgumentError());
        }

        _module = module;

        _evaluated = false;
        _singletonScope = false;
    }

    public function to(type : Class<T1>, ?func : Function0<Array<Dynamic>>) : Scope {
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

    public function toInstance(instance : T1) : Scope {
        if (null == instance) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = Instance(instance);
        return this;
    }

    public function toProvider(provider : Class<Provider<T1>>) : Scope {
        if (null == provider) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = Provider(provider);
        return this;
    }

    public function getInstance() : T1 {
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

    private function solve() : T1 {
        return switch(_bindingType) {
            case To(type, func): Reflects.createInstance(type, func());
            case Instance(instance): instance;
            case Provider(provider): Reflects.createEmptyInstance(provider).get();
            default:
                Funk.error(BindingError("Invalid Bind"));
        }
    }

    private function get_boundTo() : T2 {
        return _boundTo;
    }

    private function set_boundTo(value : T2) : T2 {
        _boundTo = value;
        return _boundTo;
    }
}
