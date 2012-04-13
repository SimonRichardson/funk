describe("funk", function () {
    describe("option", function () {
        describe("Some", function () {
            "use strict";

            it("should be defined", function () {
                expect(some({}).isDefined).toBeTruthy();
            });

            it("should be empty", function () {
                expect(some({}).isEmpty).toBeFalsy();
            });

            it("should actual value match expected value", function () {
                var value = {};

                expect(some(value).get()).toStrictlyEqual(value);
            });

            it("should expected value be undefined if actual value is undefined", function () {
                expect(some(undefined).get()).toBeUndefined();
            });

            it("should expected value be null if actual value is null", function () {
                expect(some(null).get()).toBeNull();
            });

            describe("when getOrElse on some", function () {

                it("should not call orElse closure", function () {
                    var value = {};

                    expect(some(value).getOrElse(function () {
                        fail();
                    })).toStrictlyEqual(value);
                });
            });

            describe("when filter on some", function () {

                it("should pass the same instance as an argument", function () {
                    var value = {};
                    some(value).filter(function (v) {
                        expect(value).toStrictlyEqual(v);
                    });
                });

                it("should return a valid option", function () {
                    var value = {};
                    var actual = some(value).filter(function (v) {
                        return v === value;
                    });

                    expect(value).toStrictlyEqual(actual.get());
                });

                it("should return a invalid option", function () {
                    var value = {};
                    var actual = some(value).filter(function (v) {
                        return v !== value;
                    });

                    expect(none()).not.toStrictlyEqual(actual);
                });
            });

            describe("when foreach on some", function () {

                it("should pass the same instance as an argument", function () {
                    var value = {};

                    some(value).filter(function (v) {
                        expect(value).toStrictlyEqual(v);
                    });
                });

                it("should iterate through value", function () {
                    var value = {};
                    var count = 0;

                    some(value).foreach(function (v) {
                        count++;
                    });

                    expect(count).toEqual(1);
                });
            });

            describe("when flatMap on some", function () {

                it("should pass the same instance as an argument", function () {
                    var value = {};

                    some(value).flatMap(function (v) {
                        expect(value).toStrictlyEqual(v);
                        return some(v);
                    });
                });

                it("should result in the same value", function () {
                    var value = {};

                    var actual = some(value).flatMap(function (v) {
                        return some(v);
                    });

                    expect(value).toStrictlyEqual(actual.get());
                });

                it("should result in an TypeError if invalid result", function () {
                    var value = {};

                    expect(
                        function () {
                            some(value).flatMap(indentity);
                        }).toThrow(new funk.error.TypeError());
                });
            });

            describe("when map on some", function () {

                it("should map the value", function () {
                    var value = 1234;
                    var func = function (x) {
                        return x.toString();
                    }

                    expect(some(value).map(func).get()).toStrictlyEqual(func(value));
                });

                it("should map be called multiple times should be the same value", function () {
                    var value = 1234;
                    var func = function (x) {
                        return x.toString();
                    }

                    expect(some(value).map(func).get()).toStrictlyEqual(some(value).map(func).get());
                });

                it("should map result equal the value entered in some", function () {
                    var value = 1234;
                    var func = function (x) {
                        return x.toString();
                    }

                    expect(some(func(value)).equals(some(value).map(func))).toBeTruthy();
                });
            });

            describe("when orElse on some", function () {

                it("should not call orElse closure", function () {
                    var op = some(true);

                    expect(op.orElse(
                        function () {
                            fail();
                        }).get()).toBeTruthy();
                });

                it("should result in the same value", function () {
                    var op = some(true);

                    expect(op.orElse(function () {
                        fail();
                    })).toStrictlyEqual(op);
                });
            });

            describe("when equals on some", function () {

                it("should some value 1 equal another some value 1", function () {
                    expect(some(1).equals(some(1))).toBeTruthy();
                });

                it("should some value null equal another some value null", function () {
                    expect(some(null).equals(some(null))).toBeTruthy();
                });

                it("should some value undefined equal another some value undefined", function () {
                    expect(some(undefined).equals(some(undefined))).toBeTruthy();
                });

                it("should some value {} equal same some value {}", function () {
                    var value = {};
                    expect(some(value).equals(some(value))).toBeTruthy();
                });

                it("should some value {} not equal another some value {}", function () {
                    expect(some({}).equals(some({}))).toBeFalsy();
                });

                it("should some nested be equal to some nested", function () {
                    expect(some(some(1)).equals(some(some(1)))).toBeTruthy();
                });

                it("should some equal match native object match", function () {
                    expect(some(1).equals(some("1"))).toEqual(Object(1) == Object("1"));
                });
            });

            describe("when toString on some", function () {

                it("should some value be null", function () {
                    expect(some(null).toString()).toEqual("Some(null)");
                });

                it("should some value be undefined", function () {
                    expect(some(undefined).toString()).toEqual("Some(undefined)");
                });

                it("should some value be Array (1,2,3)", function () {
                    expect(some([1, 2, 3]).toString()).toEqual("Some(1,2,3)");
                });

                it("should some value be 1", function () {
                    expect(some(1).toString()).toEqual("Some(1)");
                });

                it("should some value be 1 (as a string)", function () {
                    expect(some("1").toString()).toEqual("Some(1)");
                });

                it("should some value be {}", function () {
                    expect(some({}).toString()).toEqual("Some([object Object])");
                });

                it("should some value be true", function () {
                    expect(some(true).toString()).toEqual("Some(true)");
                });

                it("should some value be false", function () {
                    expect(some(false).toString()).toEqual("Some(false)");
                });
            });

            describe("when product on some", function () {

                it("should have product arity of 1", function () {
                    expect(some(true).productArity()).toStrictlyEqual(1);
                });

                it("should have product prefix of Some", function () {
                    expect(some(true).productPrefix()).toStrictlyEqual("Some");
                });

                it("should have product element at 0 of true", function () {
                    expect(some(true).productElement(0)).toBeTruthy();
                });

                it("should throw RangeError for product element at 1", function () {
                    expect(
                        function () {
                            some(true).productElement(1)
                        }).toThrow(new funk.error.RangeError());
                });
            });
        });
    });
});