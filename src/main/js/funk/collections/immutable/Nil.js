funk.collection = funk.collection || {};
funk.collection.immutable = funk.collection.immutable || {};
funk.collection.immutable.Nil = (function(){
    "use strict";
    var NilImpl = function(){};
    NilImpl.prototype = new funk.collection.List();
    NilImpl.prototype.constructor = NilImpl;
    NilImpl.prototype.name = "Nil";
    NilImpl.prototype.product$equals = NilImpl.prototype.equals;
    NilImpl.prototype.equals = function(value){
        if(value instanceof funk.option.Some) {
            return this.product$equals(value.get());
        }
        return this.product$equals(value);
    }
    NilImpl.prototype.head = function(){
        return funk.option.none();
    };
    NilImpl.prototype.tail = function(){
        return funk.option.none();
    };
    NilImpl.prototype.last = function(){
        return funk.option.none();
    };
    NilImpl.prototype.drop = function(index){
        funk.util.require(index >= 0, "index must be positive.");
        return this;
    };
    NilImpl.prototype.dropRight = function(index){
        funk.util.require(index >= 0, "index must be positive.");
        return this;
    };
    NilImpl.prototype.dropWhile = function(func){
        return this;
    };
    NilImpl.prototype.filter = function(func){
        return this;
    };
    NilImpl.prototype.filterNot = function(func){
        return this;
    };
    NilImpl.prototype.find = function(func){
        return funk.option.none();
    };
    NilImpl.prototype.flatMap = function(func){
        return this;
    };
    NilImpl.prototype.foldLeft = function(value, func){
        return value;
    };
    NilImpl.prototype.foldRight = function(value, func){
        return value;
    };
    NilImpl.prototype.forall = function(func){
        return false;
    };
    NilImpl.prototype.foreach = function(func){
    };
    NilImpl.prototype.indices = function(){
        return this;
    };
    NilImpl.prototype.init = function(){
        return this
    };
    NilImpl.prototype.map = function(func){
        return this;
    };
    NilImpl.prototype.partition = function(func){
        return funk.tuple.tuple2(this, this);
    };
    NilImpl.prototype.prepend = function(value){
        return new funk.collection.immutable.List(value, this)
    };
    NilImpl.prototype.prependAll = function(value){
        return value;
    };
    NilImpl.prototype.reduceLeft = function(func){
        return undefined;
    };
    NilImpl.prototype.reduceRight = function(func){
        return undefined;
    };
    NilImpl.prototype.reverse = function(){
        return this;
    };
    NilImpl.prototype.take = function(index){
        require(index >= 0, "index must be positive.");
        return this;
    };
    NilImpl.prototype.takeRight = function(index){
        require(index >= 0, "index must be positive.");
        return this;
    };
    NilImpl.prototype.takeWhile = function(func){
        return this;
    };
    NilImpl.prototype.zip = function(that){
        return this;
    };
    NilImpl.prototype.zipWithIndex = function(){
        return this;
    };
    NilImpl.prototype.flatten = function(){
        return this;
    };
    NilImpl.prototype.get = function(index){
        throw new funk.error.RangeError();
    };
    NilImpl.prototype.indexOf = function(value){
        return -1;
    };
    NilImpl.prototype.findIndexOf = function(func){
        return -1;
    };
    NilImpl.prototype.contains = function(value) {
        return false;
    };
    NilImpl.prototype.count = function(func){
        return 0;
    };
    NilImpl.prototype.exists = function(func){
        return false;
    };
    NilImpl.prototype.nonEmpty = function(){
        return false;
    };
    NilImpl.prototype.isEmpty = function(){
        return true;
    };
    NilImpl.prototype.size = function(){
        return 0;
    };
    NilImpl.prototype.hasDefinedSize = function(){
        return true;
    };
    NilImpl.prototype.append = function(value){
        return new funk.collection.immutable.List(value, this);
    };
    NilImpl.prototype.appendAll = function(value){
        return value;
    };
    NilImpl.prototype.iterator = function() {
        return funk.collection.NIL_ITERATOR;
    };
    NilImpl.prototype.prependIterator = function(iterator){
        return iterator.toList();
    };
    NilImpl.prototype.prependIterable = function(iterable){
        return iterable.iterator().toList();
    };
    NilImpl.prototype.appendIterator = function(iterator){
        return iterator.toList();
    };
    NilImpl.prototype.appendIterable = function(iterable){
        return iterable.iterator().toList();
    };
    NilImpl.prototype.productArity = function(){
        return 0;
    };
    NilImpl.prototype.productElement = function(i){
        throw new funk.error.RangeError();
    };
    NilImpl.prototype.productPrefix = function(){
        return "List";
    };
    NilImpl.prototype.toArray = function(){
        return [];
    };
    return NilImpl;
})();

funk.collection.immutable.NIL = new funk.collection.immutable.Nil();
funk.collection.immutable.nil = function(){
    if(arguments.length > 0) {
        throw new funk.error.ArgumentError('Unexpected arguments');
    }
    return funk.collection.immutable.NIL;
};

// Alias
var nil = funk.collection.immutable.nil;