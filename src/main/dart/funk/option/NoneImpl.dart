class NoneImpl<T> extends Product<T> implements IOption<T> {
  
  static NoneImpl _none;
  
  factory NoneImpl(){
    if(_none == null) {
      _none = new NoneImpl();
    }
    return _none;
  }
  
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
    throw new NoSuchElementException();
  }
  
  bool get isDefined() => false;

  bool get isEmpty() => true;
  
  int get productArity() => 0;

  String get productPrefix() {
    return "None";
  }
  
  T productElement(int index){
    throw new RangeError();
  }
}
