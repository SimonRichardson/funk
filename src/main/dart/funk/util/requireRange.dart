requireRange(int i, int end) {
  if(i < 0 || i >= end) {
    throw new RangeError("Index {i} is out of range.");
  }
}