class BindingException implements Exception {
  String _msg; 
  BindingException(this._msg);
  String toString() => "BindingException: '${_msg}'";
}
