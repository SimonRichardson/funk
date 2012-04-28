class None<T> extends Product<T> implements Option<T> {
  
  static None _instance;
  
  factory None(){
    if(_instance == null) {
      _instance = new None._internal();
    }
    return _instance;
  }
  
  None._internal();
  
  T getOrElse(final Function f) => f();

  bool equals(final IProduct<T> that) {
    if (that is Option) {
      Option<T> option = that;
      return !option.isDefined;
    }

    return false;
  }

  void foreach(final Function func) {
  }

  Option<T> filter(final Function func) => this;
  
  Option<T> flatMap(final Function func) => this;

  Option<T> map(final Function func) => this;

  Option<T> orElse(final Function func) => func();
  
  T get get() {
    throw new NoSuchElementException.empty();
  }
  
  bool get isDefined() => false;

  bool get isEmpty() => true;
  
  int get productArity() => 0;

  String get productPrefix() {
    return "None";
  }
  
  T productElement(final int index){
    throw new RangeError.empty();
  }
}

get none() => new None();
