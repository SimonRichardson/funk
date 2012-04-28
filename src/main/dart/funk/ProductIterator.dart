class ProductIterator<T> implements Iterator<T> {
  
  IProduct<T> _product;
  
  int _arity;
  int _index;
  
  ProductIterator(IProduct<T> product){
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
