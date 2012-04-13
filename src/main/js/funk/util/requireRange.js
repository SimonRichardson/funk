funk.util = funk.util || {};
funk.util.requireRange = function(i, end, start){
    start = funk.isDefined(start) ? start : 0;
    if(i < start || i >= end) {
        throw new funk.error.RangeError("Index " + i + " is out of range.");
    }
};

// Alias
var requireRange = funk.util.requireRange;