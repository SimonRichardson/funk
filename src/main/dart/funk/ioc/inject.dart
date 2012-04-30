inject(Type type) {
  if(type == null) {
    throw new ArgumentError("Given type must not be null.");
  }
  
  final Injector injector = new Injector();
  final IModule currentScope = when(injector.currentScope, {
    "none": () => null,
    "some": (value) => value
  });

  if(null == currentScope) {
    return injector.scopeOf(type).getInstance(type);
  }

  return currentScope.getInstance(type);
}
