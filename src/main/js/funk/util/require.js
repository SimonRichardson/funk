funk.util = funk.util || {};
funk.util.require = function(condition, message) {
    if(!condition) {
        throw new funk.error.ArgumentError(message);
    }
};

// Alias
var require = funk.util.require;