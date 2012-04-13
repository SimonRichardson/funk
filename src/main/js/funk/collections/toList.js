funk.collection = funk.collection || {};
funk.collection.toList = function(value){
    "use strict";
    var result = nil();
    var index = 0;

    if(value === funk.verifiedType(value, funk.collection.List)) {
        return value;
    } else if(funk.isArray(value)) {
        index = value.length;

        while(--index > -1) {
            result = result.prepend(value[index]);
        }

        return result;
    } else if(funk.isArguments(value)) {
        var items = funk.toArray(value);

        index = value.length;

        while(--index > -1) {
            result = result.prepend(value[index]);
        }

        return result;
    } else if(funk.isString(value)) {
        index = value.length;

        while(--index > -1) {
            result = result.prepend(value.substr(index, 1));
        }

        return result;
    } else {
        return list(value);
    }
};

var toList = funk.collection.toList;