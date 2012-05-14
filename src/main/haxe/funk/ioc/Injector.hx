package funk.ioc;

class Injector {
	
	private static var _map : ISet<Class<Dynamic>, IModule> = nil.set();
	
	private static var _scopes : IList<IModule> = nil.list();
	
	private static var _modules : IList<IModule> = nil.list();
	
	private static var _currentScope : Option<IModule>;
	
	public function new() {
		// TODO (Simon) : Throw error
	}
	
	public static function pushScope(module : IModule) : Void {
		_currentScope = module;
		_scopes = _scopes.prepend(module);
	}
	
	public static function popScope() : Void {
		_scopes = _scopes.tail;
		_currentScope = _scopes.headOption;
	}
	
	public static function currentScope() : Option<IModule> {
		return _currentScope;
	}
	
	
	
}
