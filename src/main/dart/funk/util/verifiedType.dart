verifiedType(instance, Type type) {
  if(type.isType(instance)) {
    return instance;
  }
  
  throw new TypeException("Expected: {type}, Actual: {instance}.");
}
