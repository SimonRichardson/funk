class NoSuchElementException implements Exception {
  String _msg; 
  NoSuchElementException(this._msg);
  NoSuchElementException.empty() {
    this._msg = "No such element found";
  }
  String toString() => "NoSuchElementException: '${_msg}'";
}
