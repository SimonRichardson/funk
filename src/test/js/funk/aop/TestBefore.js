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

            it("should call aspect with correct method name", function(){
                before(MockObject, 'returnValue', function(method, args){
                    expect(method).toBeStrictlyEqualTo('returnValue');
                });
                new MockObject().returnValue();
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
        });
    });
});