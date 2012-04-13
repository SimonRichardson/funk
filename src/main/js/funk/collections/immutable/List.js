funk.collection = funk.collection || {};
funk.collection.immutable = funk.collection.immutable || {};
funk.collection.immutable.List = (function(){
    var ListImpl = function(){};
    ListImpl.prototype = new funk.collection.List();
    ListImpl.prototype.constructor = ListImpl;

    ListImpl.prototype.name = "List";
    return ListImpl;
})();