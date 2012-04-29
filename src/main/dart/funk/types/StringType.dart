class StringType extends Type<String> {
  
  String _value;
  
  StringType(){
  }
  
  String create([List args]) {
    if(args != null) {
      _value = args[0];
    }
  }
  
  int hashCode() {
    return _value.hashCode();
  }
  
  bool equals(IFunkObject value) => hashCode() == value.hashCode();
}
