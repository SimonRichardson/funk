eq(final a, final b) {
  if(a is IFunkObject && b is IFunkObject) {
    return a.equals(b);
  }
  return a == b;
}
