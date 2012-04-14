funk.collection = funk.collection || {};
funk.collection.Iterable = (function(){
    "use strict";
    var IterableImpl = function(){};
    IterableImpl.prototype = {};
    IterableImpl.prototype.constructor = IterableImpl;
    IterableImpl.prototype.name = "Iterable";
    IterableImpl.prototype.iterator = function(){
        funk.util.isAbstract();
    };
    return IterableImpl;
})();