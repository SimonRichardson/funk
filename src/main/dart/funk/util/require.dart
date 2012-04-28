require(bool condition, String message) {
  if(!condition) {
    throw new ArgumentError([]);
  }
}