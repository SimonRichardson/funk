funk.pass = {
    any: function(value){
        return value;
    },
    string: function(value){
        return funk.util.verifiedType(value, String);
    },
    boolean: function(value){
        return funk.util.verifiedType(value, Boolean);
    },
    integer: function(value){
        if(funk.isInteger(value)) {
            return value;
        }
        throw new funk.error.TypeError("Expected: int, Actual: " + value);
    },
    number: function(value){
        return funk.util.verifiedType(value, Number);
    },
    object: function(value){
        return funk.util.verifiedType(value, Object);
    },
    instanceOf: function(value){
        return new value;
    }
};