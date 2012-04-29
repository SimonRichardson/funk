class Some<T> extends Product<T> implements Option<T> {
  
  T _value;
  
  Some(final T value){
    _value = value;
  }
    
  T getOrElse(final Function f) => _value;

  int hashCode() {
    T h = get;
    if(h is Hashable) {
      Hashable hash = h;
      return hash.hashCode();
    } 
    return 0;
  }
  
  bool equals(final IFunkObject that) {
    if (that is Option) {
      Option<T> option = that;
      if(option.isDefined) {
        return eq(get, option.get);
      }
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