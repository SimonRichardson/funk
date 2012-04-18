describe("funk", function () {
    describe("ioc", function () {
        describe("Injector", function () {
            "use strict";

            describe("when injecting string", function(){
                var value = "Test";
                var module;

                beforeEach(function(){
                    module = funk.ioc.Injector.initialize(funk.ioc.createModule(function(module){
                        this.bind(String).toInstance(value);
                    }));
                });

                it("should string not be null", function(){
                    var object = module.getInstance(funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }));
                    expect(object.string).not.toBeNull();
                });

                it("should string be equal to \"Test\"", function(){
                    var object = module.getInstance(funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }));
                    expect(object.string).toBeStrictlyEqualTo(value);
                });
            });
        });
    });
});