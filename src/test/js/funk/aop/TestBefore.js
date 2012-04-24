describe("funk", function(){
    describe("aop", function(){
        describe("before", function(){

            afterEach(function(){
                Aspect.removeAll();
            });

            it("should call aspect before returnValue", function(){
                var called = false;
                before(MockObject, 'returnValue', function(method, args){
                    called = true;
                });
                new MockObject().returnValue();
                expect(called).toBeTruthy();
            });

            it("should call aspect with correct number of arguments (0)", function(){
                before(MockObject, 'returnValue', function(method, args){
                    expect(args.length).toBeStrictlyEqualTo(0);
                });
                new MockObject().returnValue();
            });

            it("should call aspect with correct number of arguments (1)", function(){
                before(MockObject, 'returnValue', function(method, args){
                    expect(args.length).toBeStrictlyEqualTo(1);
                });
                new MockObject().returnValue("Hello");
            });

            it("should call aspect with correct number of arguments (2)", function(){
                before(MockObject, 'returnValue', function(method, args){
                    expect(args.length).toBeStrictlyEqualTo(2);
                });
                new MockObject().returnValue("Hello", "World!");
            });

            it("should call aspect with correct argument", function(){
                var value = "Hello";
                before(MockObject, 'returnValue', function(method, args){
                    expect(args[0]).toBeStrictlyEqualTo(value);
                });
                new MockObject().returnValue(value);
            });

            it("should call method before mock object method", function(){
                var called = false;
                before(MockObject, 'callMe', function(method, args){
                    expect(called).toBeFalsy();
                });
                new MockObject().callMe(function(){
                    called = true;
                });
            });

            it(">>>", function(){
                var item0 = new MockObject();
                var item1 = new MockObject();
                funk.aop.flows.bind(funk.tuple.tuple2(item0, "property"),
                                    funk.tuple.tuple2(item1, "property")).add(function(tuple, value){
                        console.log("Item0: " + item0.toString(),
                                    "Item1: " + item1.toString());
                    });

                var count = 0;
                var id = setInterval(function(item0, item1){
                    if((++count % 2) == 0) {
                        item0.property(count);
                    } else {
                        item1.property(count);
                    }
                }, 100, {property: item0.property}, {property: item1.property});

                setTimeout(function(){
                    clearInterval(id);
                }, 200);
            });
        });
    });
});