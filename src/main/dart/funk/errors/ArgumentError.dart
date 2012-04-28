class ArgumentError {
  String _msg;
  ArgumentError(this._msg);
  ArgumentError.empty() {
    this._msg = "Argument error";
  }
  String toString() => "ArgumentError: '${_msg}'";
}