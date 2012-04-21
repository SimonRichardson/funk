funk.aop = funk.aop || {};
funk.aop.flows = funk.aop.flows || {};
funk.aop.flows.profile = function(source, method){
    var time = new Date().getTime();
    funk.aop.before(source, method, function(m, a){
        funk.print(funk.getName(source) + "." + method + " (start:"+time+")");
    });
    funk.aop.afterFinally(source, method, function(m, a, v){
        var elapsed = new Date().getTime() - time;
        funk.print(funk.getName(source) + "." + method + " (start:"+time+", elapsed:"+elapsed+")");
    });
};