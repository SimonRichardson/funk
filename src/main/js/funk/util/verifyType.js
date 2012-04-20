funk.util = funk.util || {};
funk.util.verifiedType = function(value, type){
    "use strict";

    if(value instanceof type) {
        return value;
    }

    throw new funk.error.TypeError("Expected: " + funk.getName(type) + ", Actual: " + funk.getName(value));
};

// Alias
var verifiedType = funk.util.verifiedType;