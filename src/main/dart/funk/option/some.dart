class Some<T> extends Product<T> implements Option<T> {
  
  T _value;
  
  Some(final T value){
    _value = value;
  }
    
  T getOrElse(final Function f) => _value;

  bool equals(final IProduct<T> that) {
    if (that is Option) {
      Option<T> option = that;
      return !option.isDefined;
    }

    return false;
  }

  void foreach(final Function func) {
    func(get);
  }

  Option<T> filter(final Function func) => func(get) == true ? this : none();
  
  Option<T> flatMap(final Function func) => func(get);

  Option<T> map(final Function func) => some(func(get));

  Option<T> orElse(final Function func) => this;
  
  T get get() => _value;
  
  bool get isDefined() => true;

  bool get isEmpty() => false;
  
  int get productArity() => 1;

  String get productPrefix() {
    return "Some";
  }
  
  T productElement(final int index){
    if(index == 0) {
      return get;
    }
    throw new RangeError.empty();
  }
}


some(final value) => new Some(value);