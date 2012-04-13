funk.ProductIterator = (function(){
    var ProductIteratorImpl = function(product){
        this._product = product;
        this._arity = product.productArity();
        this._index = 0;
    };
    ProductIteratorImpl.prototype = new funk.collection.Iterator();
    ProductIteratorImpl.prototype.constructor = ProductIteratorImpl;
    ProductIteratorImpl.prototype.hasNext = function(){
        return this._index < this._arity;
    };
    ProductIteratorImpl.prototype.next = function(){
        if(this.hasNext()) {
            return funk.option.some(this._product.productElement(this._index++));
        }
        return funk.option.none();
    };
    ProductIteratorImpl.prototype.name = "ProductIterator";
    return ProductIteratorImpl;
})();