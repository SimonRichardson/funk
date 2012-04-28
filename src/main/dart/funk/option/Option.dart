interface Option<T> extends IProduct<T> default None<T> {
  
  T getOrElse(Function func);

  Option<T> filter(Function func);

  void foreach(Function func);

  Option<T> flatMap(Function func);
  
  Option<T> map(Function func);

  Option<T> orElse(Function func);
  
  T get get();
  
  bool get isDefined();

  bool get isEmpty();
}
