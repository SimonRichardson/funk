describe("funk", function () {
    describe("ioc", function () {
        describe("Injector", function () {
            "use strict";

            it("should inject String into mock object", function(){
                var module = funk.ioc.Injector.initialize(new MockModule());
                var object = module.getInstance(MockObject);
            });

        });
    });
});