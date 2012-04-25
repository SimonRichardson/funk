class SomeImpl<T> extends Product<T> implements IOption<T> {
  
  T _value;
  
  SomeImpl(value){
    _value = value;
  }
    
  T getOrElse(Function f) => _value;

  bool equals(IProduct<T> that) {
    if (that is IOption) {
      IOption<T> option = that;
      return !option.isDefined;
    }

    return false;
  }

  void foreach(Function func) {
    func(get);
  }

  IOption<T> filter(Function func) => func(get) == true ? this : none();
  
  IOption<T> flatMap(Function func) => func(get);

  IOption<T> map(Function func) => some(func(get));

  IOption<T> orElse(Function func) => this;
  
  T get get() => _value;
  
  bool get isDefined() => true;

  bool get isEmpty() => false;
  
  int get productArity() => 1;

  String get productPrefix() {
    return "Some";
  }
  
  T productElement(int index){
    if(index == 0) {
      return get;
    }
    throw new RangeError();
  }
}
