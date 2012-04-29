class Type<T> implements IFunkObject {
  
  abstract T create([List args]);
  
  abstract int hashCode();
  
  bool isType(obj) => obj is T;
}
