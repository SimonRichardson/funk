describe("funk", function(){
    describe("aop", function(){
        describe("bind", function(){

            var id = 0;

            afterEach(function(){
                clearInterval(id);

                Aspect.removeAll();
            });

            it("should item0 and item1 be equal to each other after 1 iteration", function(){
                var item0 = new MockObject();
                var item1 = new MockObject();

                funk.aop.flows.bind(funk.tuple.tuple2(item0, "property"),
                                    funk.tuple.tuple2(item1, "property"));

                for(var i = 0; i < 1; i++) {
                    item0.property(10);
                }

                expect(item1.property()).toBeStrictlyEqualTo(10);
            });

            it("should item0 be equal to iteself after 1 iteration", function(){
                var item0 = new MockObject();
                var item1 = new MockObject();

                funk.aop.flows.bind(funk.tuple.tuple2(item0, "property"),
                    funk.tuple.tuple2(item1, "property"));

                for(var i = 0; i < 1; i++) {
                    item0.property(10);
                }

                expect(item0.property()).toBeStrictlyEqualTo(10);
            });

            it("should item0 and item1 be equal to each other after 10 iterations", function(){
                var item0 = new MockObject();
                var item1 = new MockObject();

                funk.aop.flows.bind(funk.tuple.tuple2(item0, "property"),
                    funk.tuple.tuple2(item1, "property"));

                for(var i = 0; i < 10; i++) {
                    item0.property(i + 1);
                }

                expect(item1.property()).toBeStrictlyEqualTo(10);
            });

            it("should item0 be equal to itself after 10 iterations", function(){
                var item0 = new MockObject();
                var item1 = new MockObject();

                funk.aop.flows.bind(funk.tuple.tuple2(item0, "property"),
                    funk.tuple.tuple2(item1, "property"));

                for(var i = 0; i < 10; i++) {
                    item0.property(i + 1);
                }

                expect(item0.property()).toBeStrictlyEqualTo(10);
            });

            it("should call the bind method signal after a change", function(){
                var item0 = new MockObject();
                var item1 = new MockObject();

                var called = false;
                funk.aop.flows.bind(funk.tuple.tuple2(item0, "property"),
                    funk.tuple.tuple2(item1, "property")).add(function(){
                        called = true;
                    });

                item0.property(10);

                expect(called).toBeTruthy();
            });
        });
    });
});