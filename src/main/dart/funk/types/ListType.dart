class ListType<T> extends Type<IList<T>> {
  
  IList<T> _value;
  
  ListType(){
  }
  
  IList<T> create([List args]) {
    if(args != null) {
      _value = args[0];
    }
  }
  
  int hashCode() {
    return _value.hashCode();
  }
  
  bool equals(IFunkObject value) => hashCode() == value.hashCode();
}
