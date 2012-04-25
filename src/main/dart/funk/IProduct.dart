interface IProduct<T> extends IImmutable, Iterable {
  
  T productElement(int index);

  int get productArity();

  String get productPrefix();
}
