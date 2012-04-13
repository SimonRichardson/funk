funk.collection = funk.collection || {};
funk.collection.Iterator = (function(){
    "use strict";
    var IteratorImpl = function(){};
    IteratorImpl.prototype = {};
    IteratorImpl.prototype.name = "Iterator";
    IteratorImpl.prototype.hasNext = function(){
        return false;
    };
    IteratorImpl.prototype.next = function(){
        return none();
    };
    IteratorImpl.prototype.equals = function(value){
        return funk.collection.util.iterator.eq(this, value);
    };
    IteratorImpl.prototype.toArray = function(){
        return funk.collection.util.iterator.toArray(this);
    };
    IteratorImpl.prototype.toList = function(){
        return funk.collection.util.iterator.toList(this);
    };
    IteratorImpl.prototype.toString = function(){
        return this.name;
    };
    return IteratorImpl;
})();