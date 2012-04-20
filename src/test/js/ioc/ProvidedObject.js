var ProvidedObject = (function(){
    "use strict";
    var ProvidedObjectImpl = function(){
        funk.ioc.Provider.call(this);

        ProvidedObjectImpl.singleton = inject(SingletonInstance);
    };
    ProvidedObjectImpl.prototype = new MockProviderObject();
    ProvidedObjectImpl.prototype.constructor = ProvidedObjectImpl;
    ProvidedObjectImpl.prototype.name = "ProvidedObject";
    return ProvidedObjectImpl;
})();