package funk.ioc;

import funk.Funk;

using funk.types.Pass;
using funk.types.Option;
using funk.types.Provider;
using funk.types.Function0;
using funk.types.Any;
using funk.types.extensions.Bools;

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
        if (module.toBool()) Funk.error(ArgumentError());

        _module = module;

        _evaluated = false;
        _singletonScope = false;
    }

    public function to(type : Class<T>, ?func : Function0<Array<Dynamic>>) : Scope {
        if (type.toBool()) Funk.error(ArgumentError());
        if (func.toBool()) {
            func = function () {
                return [];
            };
        }

        _evaluated = false;
        _bindingType = To(type, func);

        return this;
    }

    public function toInstance(instance : T) : Scope {
        if (instance.toBool()) Funk.error(ArgumentError());

        _evaluated = false;
        _bindingType = Instance(instance);

        return this;
    }

    public function toProvider(provider : Class<Provider<T>>) : Scope {
        if (provider.toBool()) Funk.error(ArgumentError());

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

    public function asSingleton() : Void _singletonScope = true;

    private function solve() : T {
        return switch(_bindingType) {
            case To(type, func): Pass.instanceOf(type, func())();
            case Instance(instance): instance;
            case Provider(provider): Pass.instanceOf(provider)().get();
        }
    }
}
