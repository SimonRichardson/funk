class Type<T> implements IFunkObject {
  
  static int HASH_SEED = 0;
  
  abstract T create([List args]);
  
  abstract int hashCode();
  
  bool isType(obj) => obj is T;
}
