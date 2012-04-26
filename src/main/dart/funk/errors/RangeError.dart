class RangeError {
  String _msg;
  RangeError(this._msg);
  RangeError.empty() {
    this._msg = "Range error";
  }
  String toString() => "RangeError: '${_msg}'";
}