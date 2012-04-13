funk.util = funk.util || {};
funk.util.ne = function(a, b) {
    "use strict";
    return !funk.util.eq(a, b);
};

// Alias
var ne = funk.util.ne;