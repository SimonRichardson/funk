class ProductIterator<T> implements Iterator<T> {
  
  Product<T> _product;
  
  int _arity;
  int _index;
  
  ProductIterator(Product<T> product){
    _product = product;
    _arity = product.productArity;
    _index = 0;
  }
  
  bool hasNext() => _index < _arity;
  
  T next() {
    if(hasNext()) {
      return _product.productElement(_index++);
    }
    return null;
  }
}
