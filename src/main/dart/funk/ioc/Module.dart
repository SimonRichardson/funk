abstract class Module implements IModule {
	
	bool _initialized;
	
	Map<Type, Binding> _map;
	
	Module(){
		_map = new HashMap();
		_initialized = false;
	}
	
	abstract void configure();
	
	void intialize() {
		configure();
		_initialized = true;
	}
	
	Binding bind(Type type) {
		if(_map[type] != null) {
			throw new BindingException("{type} is already bound.");
		}
		
		final Binding binding = new Binding(this, type);
		_map[type] = binding;
		return binding;
	}
	
	getInstance(Type type) {
		if(!_initialized) {
			throw new BindingException("Modules have to be created using \"Injector.initialize(new Module())\".");
		}
		
		final Binding binding = _map[type];
		
		final Injector injector = new Injector();
		
		try {
		  injector.pushScope(this);
			return (binding == null) ? type.create() : binding.getInstance();
		} finally {
		  injector.popScope();	
		}
	}
	
	bool binds(Type type) {
		return _map[type] != null;
	}
}