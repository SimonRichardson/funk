funk.option = funk.option || {};
funk.option.toValue = function(value){
    if(value instanceof funk.option.Option) {
        value = funk.option.when(value, {
            some: function(value){
                return value;
            }
        });
    }
    return value;
};

// Alias
var toValue = funk.option.toValue;