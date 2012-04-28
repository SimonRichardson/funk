class Type<T> implements Hashable {
  
  abstract T create();
  
  abstract int hashCode();
  
  bool isType(obj) => obj is T;
}
