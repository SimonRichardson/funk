funk.option = funk.option || {};
funk.option.toValue = function(value){
    if(value instanceof funk.option.Option) {
        var result = funk.option.when(value, {
            none: function(){
                return value;
            },
            some: function(v){
                return v;
            }
        });
        return result;
    }
    return value;
};

// Alias
var toValue = funk.option.toValue;