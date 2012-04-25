class ProductIterator<T> {
  
  Product<T> _product;
  
  int _arity;
  int _index;
  
  ProductIterator(Product<T> product){
    _product = product;
    _arity = product.productArity;
    _index = 0;
  }
  
  bool get hasNext() => _index < _arity;
  
  T get next() {
    if(hasNext) {
      return _product.productElement(_index++);
    }
    return null;
  }
}
