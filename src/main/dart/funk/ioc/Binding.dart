class Binding<T> implements IScope {
	
	IModule _module;
	Type<T> _type;
	
	Type<T> _to;
	T _toInstance;
	Type<T> _toProvider;
	
	int _bindingType;
	bool _singletonScope;
	bool _evaluated;
	T _value;
	
	Binding(IModule module, Type<T> type){
		_module = module;
		_type = type;
		
		_bindingType = 0;
		_singletonScope = false;
		_evaluated = false;
	}
	
	IScope to(Type<T> type) {
		_to = type;
		_bindingType = 0;
		return this;
	}
	
	IScope toInstance(T instance) {
		_toInstance = instance;
		_bindingType = 1;
		return this;
	}
	
	IScope toProvider(Type<T> provider) {
		_toProvider = provider;
		_bindingType = 2;
		return this;
	}
	
	T getInstance() {
		if(_singletonScope){
			if(_evaluated) {
				return _value;
			}
			
			_value = _solve();
			_evaluated = true;
			
			return _value;
		} else {
			return _solve();
		}
 	}
 	
 	T _solve() {
 		if(0 == _bindingType) {
 			return _to == null ? _type.create() : _module.getInstance(_to);
 		} else if(1 == _bindingType) {
 			return _toInstance;
 		} else if(2 == _bindingType) {
 			return _module.getInstance(_toProvider).get();
 		} else {
 			throw new IllegalByDefinitionException("Illegal binding type");
 		}
 	}
 	
 	void asSingleton() {
 		_singletonScope = true;
 	}
}