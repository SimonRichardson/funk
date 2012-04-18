funk.util = funk.util || {};
funk.util.verifiedType = function(value, type){
    "use strict";

    if(value instanceof type) {
        return value;
    }

    var expectedName = type,
        actualName = value;

    if(funk.debug) {
         expectedName = funk.isValid(type) && funk.has(type.prototype, 'name') ? type.prototype.name : type;
         actualName = funk.isValid(value) && funk.has(value, 'name') ? value.name : value;
    }

    throw new funk.error.TypeError("Expected: " + expectedName + ", Actual: " + actualName);
};

// Alias
var verifiedType = funk.util.verifiedType;