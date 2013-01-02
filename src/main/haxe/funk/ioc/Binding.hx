package funk.ioc;

import funk.Funk;

enum BindingType<T> {
    To(type : Class<T>);
    Instance(instance : T);
    Provider(provider : Class<T>);
}

@:final
class Binding<T> {

    private var _module : Module;

    private var _bind : Class<T>;

    private var _bindingType : BindingType<T>;

    private var _singletonScope : Bool;

    private var _evaluated : Bool;

    private var _value : T;

    public function new(module : Module, bind : Class<T>) {
        _module = module;
        _bind = bind;

        _singletonScope = false;
        _evaluated = false;
    }

    public function to(type : Class<T>) : Scope {
        if (null == type) {
            Funk.error(ArgumentError());
        }

        _bindingType = To(type);
        return this;
    }

    public function toInstance(instance : T) : Scope {
        if (null == instance) {
            Funk.error(ArgumentError());
        }

        _bindingType = Instance(instance);
        return this;
    }

    public function toProvider(provider : Class<T>) : Scope {
        if (null == provider) {
            Funk.error(ArgumentError());
        }

        _bindingType = Provider(provider);
        return this;
    }

    public function getInstance() : T {
        if(_singletonScope) {
            if(_evaluated) {
                return _value;
            }

            _value = solve();
            _evaluated = true;

            return _value;
        } else {
            return solve();
        }
    }

    public function asSingleton() : Void {
        _singletonScope = true;
    }

    private function solve() : T {
        return switch(_bindingType) {
            case To(type):
                switch (_module.getInstance(type)) {
                    case Some(v): v;
                    case None: Type.createInstance(type, []);
                }
            case Instance(instance): instance;
            case Provider(provider):
                switch (_module.getInstance(provider)) {
                    case Some(v): v.get();
                    case None:
                        Funk.error(BindingError("Provider not found in module."));
                }
        }
    }
}
