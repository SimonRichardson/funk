funk.Product = (function(){
    var makeString = function(product, separator){
        var total = product.productArity();

        var buffer = "";
        for(var i=0; i<total; i++) {
            var element = product.productElement(i);
            buffer += funk.has(element, 'toString') ? element.toString() : element;
            if(i < total - 1) {
                buffer += separator;
            }
        }
        return buffer;
    };

    var ProductImpl = function(){};
    ProductImpl.prototype = {};
    ProductImpl.prototype.constructor = ProductImpl;
    ProductImpl.prototype.productArity = function(){
        funk.util.isAbstract();
    };
    ProductImpl.prototype.productElement = function(index){
        funk.util.isAbstract();
    };
    ProductImpl.prototype.productPrefix = function(){
        return "";
    };
    ProductImpl.prototype.equals = function(value){
        if(value === funk.util.verifiedType(value, funk.Product)) {
            if(this.productArity() == value.productArity()) {
                var index = this.productArity();
                while(--index > -1) {
                    if(funk.util.ne(this.productElement(index), value.productElement(index))) {
                        return false;
                    }
                }
                return true;
            }
        }
        return false;
    };
    ProductImpl.prototype.getIterator = function(){
        return new funk.ProductIterator(this);
    };
    ProductImpl.prototype.toString = function(){
        if(0 == this.productArity()) {
            return this.productPrefix();
        }
        return this.productPrefix() + "(" + makeString(this, ", ") + ")";
    };
    ProductImpl.prototype.name = "Product";
    return ProductImpl;
})();