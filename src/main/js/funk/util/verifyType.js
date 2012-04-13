funk.util = funk.util || {};
funk.util.verifiedType = function(value, type){
    "use strict";
    if(value instanceof type) {
        return value;
    }
    throw new funk.error.TypeError("Expected: " + type + ", Actual: " + value);
};

// Alias
var verifiedType = funk.util.verifiedType;