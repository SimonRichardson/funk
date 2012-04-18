funk.collection = funk.collection || {};
funk.collection.immutable = funk.collection.immutable || {};
funk.collection.immutable.ListIterator = (function(){
    var ListIteratorImpl = function(list){
        funk.collection.Iterator.call(this);

        this._list = list;
    };
    ListIteratorImpl.prototype = new funk.collection.Iterator();
    ListIteratorImpl.prototype.constructor = ListIteratorImpl;
    ListIteratorImpl.prototype.name = "ListIterator";
    ListIteratorImpl.prototype.hasNext = function(){
        return this._list.nonEmpty();
    };
    ListIteratorImpl.prototype.next = function(){
        if(this._list === nil()) {
            return funk.option.none();
        } else {
            var head = this._list.head();
            this._list = this._list.tail().get();
            return head;
        }
    };
    ListIteratorImpl.prototype.toString = function(){
        return "ListIterator";
    };
    return ListIteratorImpl;
})();