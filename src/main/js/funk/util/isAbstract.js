funk.util = funk.util || {};
funk.util.isAbstract = function(){
    throw new funk.error.AbstractMethodError();
}