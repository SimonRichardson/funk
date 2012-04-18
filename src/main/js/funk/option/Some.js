funk.option = funk.option || {};
funk.option.Some = (function(){
    "use strict";
    var SomeImpl = function(value){
        funk.option.Option.call(this);

        this._value = value;
    };
    SomeImpl.prototype = new funk.option.Option();
    SomeImpl.prototype.constructor = SomeImpl;
    SomeImpl.prototype.getOrElse = function(f) {
        return this.get();
    };
    SomeImpl.prototype.orElse = function(f){
        return this;
    };
    SomeImpl.prototype.equals = function(that) {
        if(that instanceof funk.option.Option) {
            if(that.isDefined) {
                return funk.util.eq(this.get(), that.get());
            }
        }
        return false;
    };
    SomeImpl.prototype.filter = function(f){
        return f(this.get()) === true ? this : none;
    };
    SomeImpl.prototype.foreach = function(f){
        f(this.get());
    };
    SomeImpl.prototype.flatMap = function(f){
        return funk.util.verifiedType(f(this.get()), funk.option.Option);
    };
    SomeImpl.prototype.map = function(f){
        return funk.option.some(f(this.get()));
    };
    SomeImpl.prototype.get = function(){
        return this._value;
    };
    SomeImpl.prototype.productPrefix = function(){
        return "Some";
    };
    SomeImpl.prototype.productArity = function(){
        return 1;
    };
    SomeImpl.prototype.productElement = function(index){
        if(index == 0) {
            return this.get();
        }
        throw new funk.error.RangeError();
    };
    SomeImpl.prototype.name = "Some";
    SomeImpl.prototype.isEmpty = false;
    SomeImpl.prototype.isDefined = true;
    return SomeImpl;
})();

funk.option.some = function(value){
    return new funk.option.Some(value);
};

// Alias
var some = funk.option.some;