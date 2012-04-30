class Injector {
  
  static Injector _instance;
  
  Map<Type, IModule> _map;
  
  IList<IModule> _modules;
  IList<IModule> _scopes;
  
  Option<IModule> _currentScope;
  
  factory Injector(){
    if(_instance == null) {
      _instance = new Injector._internal();
    }
    return _instance;
  }
  
  Injector._internal() {
    _map = new Map<Type, IModule>();
    _modules = nil;
    _scopes = nil;
  }
  
  IModule initialize(IModule module) {
    module.initialize();
    _modules = _modules.prepend(module);
    return module;
  }
  
  void pushScope(IModule module) {
    _currentScope = some(module);
    _scopes = _scopes.prepend(module);
  }
  
  void popScope() {
    _scopes = _scopes.tail.get;
    _currentScope = _scopes.nonEmpty ? _scopes.head : null;
  }
  
  Option<IModule> get currentScope() {
    return _currentScope;
  }
  
  IModule scopeOf(Type type) {
    IModule result;
    IModule module;
    IList<IModule> modules = _modules;
    
    while(modules.nonEmpty) {
      module = modules.head.get;
      
      if(module.binds(type)) {
        if(result != null) {
          throw new BindingException("More than one module binds {type}.");
        }
        result = modules.head.get;
      }
      
      modules = modules.tail.get; 
    }
    
    if(result == null) {
      throw new BindingException("No binding for {type} could be found.");
    }
    
    return result;
  }
  
  IModule moduleOf(Type type) {
    final possibleResult = _map[type];
    
    if(possibleResult != null) {
      return possibleResult;
    }
    
    IModule module = null;
    IList<IModule> modules = _modules;
    
    while(modules.nonEmpty) {
      module = modules.head.get;
      
      if(type.isType(module)) {
        _map[type] = module;
        return module;
      }
      
      modules = modules.tail.get; 
    }
    
    throw new BindingException("No module for {type} could be found.");
  }
}
