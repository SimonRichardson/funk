class IllegalByDefinitionException implements Exception {
  String _msg; 
  IllegalByDefinitionException(this._msg);
  IllegalByDefinitionException.empty() {
    this._msg = "Illegal by definition";
  }
  String toString() => "IllegalByDefinitionException: '${_msg}'";
}
