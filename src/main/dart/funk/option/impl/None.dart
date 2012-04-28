class None<T> extends Product<T> implements IOption<T> {
  
  static None _instance;
  
  factory None(){
    if(_instance == null) {
      _instance = new None._internal();
    }
    return _instance;
  }
  
  None._internal();
  
  T getOrElse(Function f) => f();

  bool equals(IProduct<T> that) {
    if (that is IOption) {
      IOption<T> option = that;
      return !option.isDefined;
    }

    return false;
  }

  void foreach(Function func) {
  }

  IOption<T> filter(Function func) => this;
  
  IOption<T> flatMap(Function func) => this;

  IOption<T> map(Function func) => this;

  IOption<T> orElse(Function func) => func();
  
  T get get() {
    throw new NoSuchElementException.empty();
  }
  
  bool get isDefined() => false;

  bool get isEmpty() => true;
  
  int get productArity() => 0;

  String get productPrefix() {
    return "None";
  }
  
  T productElement(int index){
    throw new RangeError.empty();
  }
}
