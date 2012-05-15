package funk.ioc;

import funk.collections.ISet;
import funk.collections.immutable.Nil;
import funk.collections.immutable.HashMap;
import funk.ioc.errors.BindingError;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.immutable.Nil;
using funk.tuple.Tuple2;

interface IModule {
	
	function initialize(): Void;
    
	function getInstance(type: Class<Dynamic>): Dynamic;
	
    function binds(type: Class<Dynamic>): Bool;
}

class Module implements IModule {
	
	private var _map: ISet<Class<Dynamic>, Binding<Dynamic>>;
    private var _initialized: Bool;

    public function new() {
		_map = nil.set();
		_initialized = false;
    }
	
	public function initialize(): Void {
		configure();
		_initialized = true;
    }
	
	public function getInstance(type: Class<Dynamic>): Dynamic {
		if(!_initialized) {
			throw new BindingError("Modules have to be created using \"Injector.initialize(new Module())\".");
		}

      	var binding = _map.find(function(item : Class<Dynamic>, bind : Binding<Dynamic>) : Bool {
			return item == type;
		});
		
      	try {
        	Injector.pushScope(this);

			var instance = switch(binding) {
				case None: Type.createInstance(type, []);
				case Some(tuple): tuple._2.getInstance();
			}
			
			Injector.popScope();
			
			return instance;
      	} catch(error : Dynamic) {
			Injector.popScope();
		}
		
		return null;
    }

    public function binds(type: Class<Dynamic>): Bool {
		var binding = _map.find(function(item : Class<Dynamic>, bind : Binding<Dynamic>) : Bool {
			return item == type;
		});
		return switch(binding) {
			case None: false;
			case Some(tuple): true;
		}
    }
    
    public function configure(): Void {
    }

    private function bind(type: Class<Dynamic>): Binding<Dynamic> {
      	if(binds(type)) {
        	throw new BindingError(Std.format("$type is already bound."));
      	}
      
      	var binding = new Binding(this, type);

      	_map = _map.add(type, binding);

      	return binding;
    }
}
