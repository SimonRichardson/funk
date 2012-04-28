interface IProduct<T> extends Iterable<T> {
  
  T productElement(int index);

  int get productArity();

  String get productPrefix();
}
