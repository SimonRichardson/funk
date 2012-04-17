funk.collection = funk.collection || {};
funk.collection.List = (function(){
    "use strict";
    var ListImpl = function(){};
    ListImpl.prototype = new funk.collection.Iterable();
    ListImpl.prototype.constructor = ListImpl;
    ListImpl.prototype.drop = function(index){
        funk.util.isAbstract();
    };
    ListImpl.prototype.dropRight = function(index){
        funk.util.isAbstract();
    };
    ListImpl.prototype.dropWhile = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.exists = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.filter = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.filterNot = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.find = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.flatMap = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.foldLeft = function(x, f){
        funk.util.isAbstract();
    };
    ListImpl.prototype.foldRight = function(x, f){
        funk.util.isAbstract();
    };
    ListImpl.prototype.forall = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.foreach = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.get = function(index){
        funk.util.isAbstract();
    };
    ListImpl.prototype.head = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.indices = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.init = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.isEmpty = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.last = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.map = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.partition = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.prepend = function(value){
        funk.util.isAbstract();
    };
    ListImpl.prototype.prependAll = function(value){
        funk.util.isAbstract();
    };
    ListImpl.prototype.reduceLeft = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.reduceRight = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.reverse = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.tail = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.take = function(index){
        funk.util.isAbstract();
    };
    ListImpl.prototype.takeRight = function(index){
        funk.util.isAbstract();
    };
    ListImpl.prototype.takeWhile = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.zip = function(that){
        funk.util.isAbstract();
    };
    ListImpl.prototype.zipWithIndex = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.size = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.hasDefinedSize = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.toArray = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.findIndexOf = function(func){
        funk.util.isAbstract();
    };
    ListImpl.prototype.flatten = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.indexOf = function(value){
        funk.util.isAbstract();
    };
    ListImpl.prototype.prependIterator = function(iterator){
        funk.util.isAbstract();
    };
    ListImpl.prototype.prependIterable = function(iterable){
        funk.util.isAbstract();
    };
    ListImpl.prototype.append = function(value){
        funk.util.isAbstract();
    };
    ListImpl.prototype.appendAll = function(value){
        funk.util.isAbstract();
    };
    ListImpl.prototype.appendIterator = function(iterator){
        funk.util.isAbstract();
    };
    ListImpl.prototype.appendIterable = function(iterable){
        funk.util.isAbstract();
    };
    ListImpl.prototype.iterator = function() {
        funk.util.isAbstract();
    };
    ListImpl.prototype.productArity = function(){
        funk.util.isAbstract();
    };
    ListImpl.prototype.productElement = function(index){
        funk.util.isAbstract();
    };
    ListImpl.prototype.productPrefix = function(){
        funk.util.isAbstract();
    };
    ListImpl.fill = function(n){
        return function(x){
            var list = nil();
            while(--n > -1) {
                list = list.prepend(x());
            }
            return list;
        }
    };
    ListImpl.fromArray = function(array){
        var list = nil();
        var index = array.length;
        while(--index > -1) {
            list = list.prepend(array[index]);
        }
        return list;
    };
    ListImpl.fromString = function(string){
        var list = nil();
        var index = string.length;
        while(--index > -1) {
            list = list.prepend(string.substr(index, 1));
        }
        return list;
    };
    ListImpl.prototype.name = "List";
    return ListImpl;
})();

funk.collection.list = function(){
    "use strict";
    var result = funk.collection.immutable.nil();

    if(arguments.length > 0) {
        var items = funk.toArray(arguments);
        var index = items.length;

        while(--index > -1) {
            result = result.prepend(items[index]);
        }
    }

    return result;
};

// Alias
var list = funk.collection.list;