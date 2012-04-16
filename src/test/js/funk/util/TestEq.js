describe("funk", function () {
    describe("util", function () {
        describe("eq", function () {
            "use strict";

            it("should 1 equal 1", function(){
                expect(eq(1, 1)).toBeTruthy();
            });

            it("should 1 not equal 2", function(){
                expect(eq(1, 2)).not.toBeTruthy();
            });

            it("should \"Hello\" equal \"Hello\"", function(){
                expect(eq("Hello", "Hello")).toBeTruthy();
            });

            it("should \"Hello\" not equal \"World\"", function(){
                expect(eq("Hello", "World")).not.toBeTruthy();
            });

            it("should instance equal itself", function(){
                var value = {};
                expect(eq(value, value)).toBeTruthy();
            });

            it("should different instances not equal itself", function(){
                expect(eq({}, {})).not.toBeTruthy();
            });

            describe("when items have equals", function(){

                it("should not call other equality", function(){
                    var obj0 = {equals: function(value){
                        return eq(1, value);
                    }};
                    var obj1 = {equals: function(){
                        fail();
                    }};
                    expect(eq(obj0, obj1)).not.toBeTruthy();
                });

                it("should be the same instance as value", function(){
                    var obj = {equals: function(value){
                        return obj === value;
                    }};
                    expect(eq(obj, obj)).toBeTruthy();
                });

                it("should capture outer scope value", function(){
                    var value1 = 1;
                    var obj = {equals: function(value){
                        return value1 === value1;
                    }};
                    expect(eq(obj, obj)).toBeTruthy();
                });

                it("should equal each other properties", function(){
                    var obj0 = {equals: function(value){
                        return eq(obj0.value, value.value);
                    }, value:"Hello"};
                    var obj1 = {equals: function(){
                        fail();
                    }, value:"Hello"};
                    expect(eq(obj0, obj1)).toBeTruthy();
                });

                it("should not equal each other properties", function(){
                    var obj0 = {equals: function(value){
                        return eq(obj0.value, value.value);
                    }, value:"Hello"};
                    var obj1 = {equals: function(){
                        fail();
                    }, value:"World"};
                    expect(eq(obj0, obj1)).not.toBeTruthy();
                });
            });

            describe("when a item is an option", function(){

                it("should some(null) equal null", function(){
                     expect(eq(some(null), null)).toBeTruthy();
                });

                it("should some(1) equal 1", function(){
                    expect(eq(some(1), 1)).toBeTruthy();
                });

                it("should some(\"Hello\") equal \"Hello\"", function(){
                    expect(eq(some("Hello"), "Hello")).toBeTruthy();
                });

                it("should some({}) equal same {}", function(){
                    var value = {};
                    expect(eq(some(value), value)).toBeTruthy();
                });

                it("should some({}) equal different {}", function(){
                    expect(eq(some({}), {})).not.toBeTruthy();
                });

                it("should none() equal false", function(){
                    expect(eq(none(), false)).toBeTruthy();
                });

                it("should none() not equal null", function(){
                    expect(eq(none(), null)).not.toBeTruthy();
                });

                it("should none() not equal undefined", function(){
                    expect(eq(none(), undefined)).not.toBeTruthy();
                });

                it("should null equal some(null)", function(){
                    expect(eq(null, some(null))).toBeTruthy();
                });

                it("should 1 equal some(1)", function(){
                    expect(eq(1, some(1))).toBeTruthy();
                });

                it("should \"Hello\" equal some(\"Hello\")", function(){
                    expect(eq("Hello", some("Hello"))).toBeTruthy();
                });

                it("should same {} equal some({})", function(){
                    var value = {};
                    expect(eq(value, some(value))).toBeTruthy();
                });

                it("should different {} equal some({})", function(){
                    expect(eq({}, some({}))).not.toBeTruthy();
                });

                it("should false equal none()", function(){
                    expect(eq(false, none())).toBeTruthy();
                });

                it("should null not equal none()", function(){
                    expect(eq(null, none())).not.toBeTruthy();
                });

                it("should undefined not equal none()", function(){
                    expect(eq(undefined, none())).not.toBeTruthy();
                });
            })
        });
    });
});