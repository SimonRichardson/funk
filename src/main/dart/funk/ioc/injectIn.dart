injectIn(Type type, Type module) {
  if(type == null) {
    throw new ArgumentError("Given type must not be null.");
  } else if(module == null) {
    throw new ArgumentError("Given module type must not be null.");
  }
  
  final Injector injector = new Injector();
  return injector.moduleOf(module).getInstance(type);
}
