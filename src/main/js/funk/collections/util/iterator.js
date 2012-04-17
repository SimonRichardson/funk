funk.collection = funk.collection || {};
funk.collection.util = funk.collection.util || {};
funk.collection.util.iterator = {
    eq: function(iterator, that){
        if(that === funk.verifiedType(that, funk.collection.Iterator)) {
            var iterAHasNext = false;
            var iterBHasNext = false;

            while(true) {
                iterAHasNext = iterator.hasNext();
                iterBHasNext = that.hasNext();

                if(iterAHasNext && iterBHasNext) {
                    if(funk.util.ne(iterator.next(), that.next())) {
                        return false;
                    }
                } else if(!iterAHasNext && !iterBHasNext) {
                    break;
                } else {
                    return false;
                }

                return true;
            }
        }
        return false;
    },
    toArray: function(iterator){
        var result = [];
        while(iterator.hasNext()) {
            result.push(iterator.next());
        }
        return result;
    },
    toList: function(iterator){
        var list = funk.collection.immutable.nil();
        while(iterator.hasNext()) {
            list = list.prepend(iterator.next());
        }
        return list.reverse();
    }
};