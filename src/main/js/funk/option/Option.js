funk.option = funk.option || {};
funk.option.Option = (function(){
    var OptionImpl = function(){
        funk.Product.call(this);
    };
    OptionImpl.prototype = new funk.Product();
    OptionImpl.prototype.constructor = OptionImpl;
    OptionImpl.prototype.name = "Option";
    return OptionImpl;
})();

funk.option.OPTION = new funk.option.Option();
funk.option.option = function(){
    if(arguments.length > 0) {
        throw new funk.error.ArgumentError('Unexpected arguments');
    }
    return funk.option.OPTION;
};

// Alias
var option = funk.option.option;