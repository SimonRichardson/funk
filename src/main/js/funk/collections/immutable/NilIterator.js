funk.collection = funk.collection || {};
funk.collection.NilIterator = (function(){
    "use strict";
    var IteratorImpl = function(){
        funk.collection.Iterator.call(this);
    };
    IteratorImpl.prototype = new funk.collection.Iterator();
    IteratorImpl.prototype.constructor = IteratorImpl;
    IteratorImpl.prototype.name = "NilIterator";
    IteratorImpl.prototype.toString = function(){
        return "NilIterator";
    };
    return IteratorImpl;
})();
funk.collection.NIL_ITERATOR = new funk.collection.NilIterator();