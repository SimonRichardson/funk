class StringType extends Type<String> {
  
  String _value;
  
  static StringType _instance;
  
  factory StringType(){
    if(_instance == null) {
      _instance = new StringType._internal();
    }
    return _instance;
  }
  
  StringType._internal();
  
  String create([List args]) {
    _value = "";
    return _value;
  }
  
  int hashCode() => 0;
  
  bool equals(IFunkObject value) => value == this;
}
