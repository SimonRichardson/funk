package funk.ioc;

enum BindingType<T> {
	To(type : Class<T>);
	Instance(instance : T);
	Provider(provicer : Class<T>);
}

class Binding<T> implements IScope {
	
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
	
	public function to(type : Class<T>) : IScope {
		_bindingType = To(type);
		return this;
	}
	
	public function toInstance(instance : T) : IScope {
		_bindingType = Instance(instance);
		return this;
	}
	
	public function toProvider(provider : Class<T>) : IScope {
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
			case To(type): (null == type) ? Type.createInstance(type, []) : _module.getInstance(type);
			case Instance(instance): instance;
			case Provider(provider): _module.getInstance(provider).get();
		}
	}
}
