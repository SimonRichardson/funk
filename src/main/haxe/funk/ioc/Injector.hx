package funk.ioc;

import funk.collections.IList;
import funk.collections.ISet;
import funk.collections.immutable.Nil;
import funk.collections.immutable.HashMap;
import funk.ioc.errors.BindingError;
import funk.ioc.Module;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.immutable.Nil;
using funk.option.Option;
using funk.tuple.Tuple2;

class Injector {
	
	private static var _map : ISet<Class<Dynamic>, IModule> = nil.set();
	
	private static var _scopes : IList<IModule> = nil.list();
	
	private static var _modules : IList<IModule> = nil.list();
	
	private static var _currentScope : Option<IModule>;
	
	public static function pushScope(module : IModule) : Void {
		_currentScope = Some(module);
		_scopes = _scopes.prepend(module);
	}
	
	public static function popScope() : Void {
		_scopes = _scopes.tail;
		_currentScope = _scopes.headOption;
	}
	
	public static function currentScope() : Option<IModule> {
		return _currentScope;
	}
	
	public static function scopeOf<T>(type: Class<T>): IModule {
		var result: IModule = null;
		var module: IModule = null;
		var modules: IList<IModule> = _modules;

      	while(modules.nonEmpty) {
        	module = modules.head;

        	if(module.binds(type)) {
          		if(null != result) {
            		throw new BindingError(Std.format("More than one module binds $type."));
          		}
          		result = modules.head;
        	}

        	modules = modules.tail;
      	}

      	if(null == result) {
        	throw new BindingError(Std.format("No binding for $type could be fond."));
      	}
      
      	return result;
    }

    public static function moduleOf<T>(type: Class<T>): IModule {
		var binding = _map.find(function(item : ITuple2<Class<Dynamic>, IModule>) : Bool {
			return item._1 == type;
		});
		
    	var possibleResult: IModule = switch(binding) {
			case None: null;
			case Some(tuple): tuple._2;
		}

      	if(null != possibleResult) {
        	return possibleResult;
      	}

      	var module: IModule = null;
      	var modules: IList<IModule> = _modules;

      	while(modules.nonEmpty) {
        	module = modules.head;

        	if(Std.is(module, type)) {
				_map = _map.add(tuple2(type, module).instance());
          		return module;
        	}

        	modules = modules.tail;
      	}

      	throw new BindingError(Std.format("No module for $type could be found."));
    }
}
