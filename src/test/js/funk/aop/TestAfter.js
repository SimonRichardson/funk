describe("funk", function(){
    describe("aop", function(){
        describe("after", function(){

            afterEach(function(){
                Aspect.removeAll();
            });

            it("should call aspect before returnValue", function(){
                var called = false;
                after(MockObject, 'returnValue', function(method, args, returnValue){
                    called = true;
                });
                new MockObject().returnValue();
                expect(called).toBeTruthy();
            });

            it("should call aspect with correct method name", function(){
                after(MockObject, 'returnValue', function(method, args, returnValue){
                    expect(method).toBeStrictlyEqualTo('returnValue');
                });
                new MockObject().returnValue();
            });

            it("should call aspect with correct number of arguments (0)", function(){
                after(MockObject, 'returnValue', function(method, args, returnValue){
                    expect(args.length).toBeStrictlyEqualTo(0);
                });
                new MockObject().returnValue();
            });

            it("should call aspect with correct number of arguments (1)", function(){
                after(MockObject, 'returnValue', function(method, args, returnValue){
                    expect(args.length).toBeStrictlyEqualTo(1);
                });
                new MockObject().returnValue("Hello");
            });

            it("should call aspect with correct number of arguments (2)", function(){
                after(MockObject, 'returnValue', function(method, args, returnValue){
                    expect(args.length).toBeStrictlyEqualTo(2);
                });
                new MockObject().returnValue("Hello", "World!");
            });

            it("should call aspect with correct argument", function(){
                var value = "Hello";
                after(MockObject, 'returnValue', function(method, args, returnValue){
                    expect(args[0]).toBeStrictlyEqualTo(value);
                });
                new MockObject().returnValue(value);
            });

            it("should call method after mock object method", function(){
                var called = false;
                after(MockObject, 'callMe', function(method, args, returnValue){
                    expect(called).toBeTruthy();
                });
                new MockObject().callMe(function(){
                    called = true;
                });
            });
        });
    });
});