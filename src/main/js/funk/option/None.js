funk.option = funk.option || {};
funk.option.None = (function(){
    "use strict";
    var NoneImpl = function(){
        funk.option.Option.call(this);
    };
    NoneImpl.prototype = new funk.option.Option();
    NoneImpl.prototype.constructor = NoneImpl;
    NoneImpl.prototype.getOrElse = function(f) {
        return f();
    };
    NoneImpl.prototype.orElse = function(f){
        return funk.util.verifiedType(f(), funk.option.Option);
    };
    NoneImpl.prototype.equals = function(that) {
        if(that instanceof funk.option.Option) {
            return !that.isDefined;
        }
        return false;
    };
    NoneImpl.prototype.filter = function(f){
        return this;
    };
    NoneImpl.prototype.foreach = function(f){
    };
    NoneImpl.prototype.flatMap = function(f){
        return this;
    };
    NoneImpl.prototype.map = function(f){
        return this;
    };
    NoneImpl.prototype.get = function(){
        throw new funk.error.NoSuchElementError();
    };
    NoneImpl.prototype.productPrefix = function(){
        return "None";
    };
    NoneImpl.prototype.productArity = function(){
        return 0;
    };
    NoneImpl.prototype.productElement = function(index){
        throw new funk.error.RangeError();
    };
    NoneImpl.prototype.isEmpty = true;
    NoneImpl.prototype.isDefined = false;
    return NoneImpl;
})();

funk.option.NONE = new funk.option.None();
funk.option.none = function(){
    if(arguments.length > 0) {
        throw new funk.error.ArgumentError('Unexpected arguments');
    }
    return funk.option.NONE;
};

// Alias
var none = funk.option.none;