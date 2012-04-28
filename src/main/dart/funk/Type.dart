abstract class Type<T> implements Hashable {
  
  abstract T create(args);
  
  abstract int hashCode();
  
  bool isType(obj) => obj is T;
}
