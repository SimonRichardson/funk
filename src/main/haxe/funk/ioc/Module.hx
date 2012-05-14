package funk.ioc;

interface IModule {
	
	function initialize(): Void;
    
	function getInstance(klass: Class<Dynamic>): Dynamic;
	
    function binds(klass: Class<Dynamic>): Boolean;
}

class Module implements IModule {
	
	private var _map: ISet<Class<Dynamic>, Binding> = new HashMap<Class<Dynamic>, Binding>();
    private var _initialized: Boolean = false;

    public function new() {
    }
	
	public function initialize(): void {
		configure();
		_initialized = true;
    }
	
	public function getInstance(klass: Class<Dynamic>): Dynamic {
		if(!_initialized) {
			throw new BindingError("Modules have to be created using \"Injector.initialize(new Module())\".");
		}

      	var binding: Binding = _map[klass];
      
      	try {
        	Injector.module_internal::pushScope(this);
        	return (null == binding) ? new klass : binding.getInstance();
      	} finally {
        	Injector.module_internal::popScope();
      	}
    }

    public function binds(klass: Class<Dynamic>): Boolean {
      	return _map[klass] != null;
    }
    
    private function configure(): Void {
    }

    private function bind(klass: Class<Dynamic>): Binding {
      	if(null != _map[klass]) {
        	throw new BindingError(klass+" is already bound.");
      	}
      
      	var binding: Binding = new Binding(this, klass);

      	_map[klass] = binding;

      	return binding;
    }
}
