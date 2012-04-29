class OptionType<T> extends Type<Option<T>> {
  
  Option<T> _value;
  
  OptionType(){
  }
  
  Option<T> create([List args]) {
    if(args != null) {
      _value = args[0];
    }
  }
  
  int hashCode() {
    return _value.hashCode();
  }
  
  bool equals(IFunkObject value) => hashCode() == value.hashCode();
}

