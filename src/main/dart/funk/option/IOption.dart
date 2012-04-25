interface IOption<T> extends IProduct<T> {
  
  T getOrElse(Function func);

  IOption<T> filter(Function func);

  void foreach(Function func);

  IOption<T> flatMap(Function func);
  
  IOption<T> map(Function func);

  IOption<T> orElse(Function func);
  
  T get get();
  
  bool get isDefined();

  bool get isEmpty();
}
