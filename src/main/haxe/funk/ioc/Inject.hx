package funk.ioc;

import funk.ioc.Module;
import funk.errors.ArgumentError;

enum Inject {
	inject;
}

class InjectType {
	
	public static function as<T>(injectEnum : Inject, type : Class<T>) : T {
		if(type == null) {
			throw new ArgumentError("Given type must not be null.");
		}
				
		return switch(Injector.currentScope()) {
			case None: Injector.scopeOf(type).getInstance(type);
			case Some(scope): scope.getInstance(type);
		}
	}
	
	public static function withIn<T>(injectEnum : Inject, type : Class<T>, module : Class<IModule>) : T {
		if(type == null) {
			throw new ArgumentError("Given type must not be null.");
		}
		if(module == null) {
			throw new ArgumentError("Given module must not be null.");
		}
		
		return Injector.moduleOf(module).getInstance(type);
	}
}
