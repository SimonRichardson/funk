funk.aop = funk.aop || {};
funk.aop.flows = funk.aop.flows || {};
funk.aop.flows.log = function(source, method){
    funk.aop.before(source, method, function(m, a){
        funk.print(funk.getName(source) + "." + method + "(" + a + ")");
    });
    funk.aop.after(source, method, function(m, a, v){
        var r = funk.isValid(v) ? "returns<" + v + ">" : "";
        funk.print(funk.getName(source) + "." + method + "(" + a + ") " + r);
    });
    funk.aop.afterThrow(source, method, function(m, a, v){
        var r = funk.isValid(v) ? "returns<" + v + ">" : "";
        funk.print(funk.getName(source) + "." + method + "(" + a + ") " + r + " <throws>");
    });
};