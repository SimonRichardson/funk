class Product<T> {
  
  Product(){
  }
  
  abstract T productElement(int index);
  
  String _makeString(String separator) {
    final int total = productArity;
    
    StringBuffer buffer = new StringBuffer();
    
    for(int i = 0; i < total; i++){
      final T element = productElement(i);
      buffer.add(element.toString());
      if(i < total - 1) {
        buffer.add(separator);
      }
    }
    
    return buffer.toString();
  }
  
  abstract int get productArity();
  
  abstract String get productPrefix();
  
  ProductIterator get iterator() => new ProductIterator(this);
  
  String toString(){
    if(0 == productArity) {
      return productPrefix;
    }
    return "${productPrefix}(${_makeString(', ')})";
  }
}
