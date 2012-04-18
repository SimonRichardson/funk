describe("funk", function () {
    describe("ioc", function () {
        describe("Injector", function () {
            "use strict";

            describe("when injecting object getInstance is not null", function(){

                it("module is not null when inject into Injector", function(){
                     expect(funk.ioc.Injector.initialize(funk.ioc.createModule(function(module){
                        // Do nothing here
                     }))).not.toBeNull();
                });

                it("module configure method can not be null, expects ArgumentError", function(){
                    expect(function(){
                        funk.ioc.Injector.initialize(funk.ioc.createModule())
                    }).toBeThrown(new funk.error.ArgumentError());
                });
            });

            describe("when injecting String", function(){
                var value = "Test";
                var module;

                beforeEach(function(){
                    module = funk.ioc.Injector.initialize(funk.ioc.createModule(function(module){
                        this.bind(String).toInstance(value);
                    }));
                });

                afterEach(function(){
                    funk.ioc.Injector.removeAll();
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

                it("should create new instance and string be equal to \"Test\"", function(){
                    var object = new (funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }))();
                    expect(object.string).toBeStrictlyEqualTo(value);
                });

                it("should string be equal to \"Test\" when getting two instances", function(){
                    var object0 = module.getInstance(funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }));
                    var object1 = module.getInstance(funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }));
                    expect(object0.string).toBeStrictlyEqualTo(object1.string);
                });

                it("should create new instance and string be equal to \"Test\" when getting two instances", function(){
                    var object0 = new (funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }))();
                    var object1 = new (funk.ioc.createObject(function(object){
                        this.string = inject(String);
                    }))();
                    expect(object0.string).toBeStrictlyEqualTo(object1.string);
                });
            });

            describe("when injecting Object", function(){
                var value = {};
                var module;

                beforeEach(function(){
                    module = funk.ioc.Injector.initialize(funk.ioc.createModule(function(module){
                        this.bind(Object).toInstance(value);
                    }));
                });

                afterEach(function(){
                    funk.ioc.Injector.removeAll();
                });

                it("should object not be null", function(){
                    var object = module.getInstance(funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }));
                    expect(object.object).not.toBeNull();
                });

                it("should object be equal to value", function(){
                    var object = module.getInstance(funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }));
                    expect(object.object).toBeStrictlyEqualTo(value);
                });

                it("should create new instance and object be equal to {}", function(){
                    var object = new (funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }))();
                    expect(object.object).toBeStrictlyEqualTo(value);
                });

                it("should object be equal to value when getting two instances", function(){
                    var object0 = module.getInstance(funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }));
                    var object1 = module.getInstance(funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }));
                    expect(object0.object).toBeStrictlyEqualTo(object1.object);
                });

                it("should create new instance and object be equal to value when getting two instances", function(){
                    var object0 = new (funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }))();
                    var object1 = new (funk.ioc.createObject(function(object){
                        this.object = inject(Object);
                    }))();
                    expect(object0.object).toBeStrictlyEqualTo(object1.object);
                });
            });
        });
    });
});