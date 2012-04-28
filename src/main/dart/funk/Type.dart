class Type<T> implements Hashable {
  
  abstract T create([List args]);
  
  abstract int hashCode();
  
  bool isType(obj) => obj is T;
}
