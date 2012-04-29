class TypeException implements Exception {
  String _msg; 
  TypeException(this._msg);
  String toString() => "TypeException: '${_msg}'";
}
