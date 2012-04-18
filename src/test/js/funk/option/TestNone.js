describe("funk", function () {
    describe("option", function () {
        describe("None", function () {
            "use strict";

            it("should not accept any arguments", function () {
                expect(
                    function () {
                        none({})
                    }).toThrow(new funk.error.ArgumentError('Unexpected arguments'));
            });

            it("should be defined", function () {
                expect(none().isDefined).toBeFalsy();
            });

            it("should be empty", function () {
                expect(none().isEmpty).toBeTruthy();
            });

            it("should have no value", function () {
                expect(
                    function () {
                        none().get()
                    }).toBeThrown(new funk.error.NoSuchElementError());
            });

            describe("when getOrElse on none", function () {

                it("should result in undefined if pass result back", function () {
                    expect(none().getOrElse(indentity)).toBeUndefined();
                });

                it("should return some value", function () {
                    var value = {};

                    expect(none().getOrElse(function () {
                        return value;
                    })).toStrictlyEqual(value);
                });
            });

            describe("when filter on none", function () {

                it("should not filter if called", function () {
                    none().filter(function (v) {
                        fail();
                    });
                });
            });

            describe("when foreach on none", function () {

                it("should not iterate if called", function () {
                    none().foreach(function (v) {
                        fail();
                    });
                });
            });

            describe("when flatMap on none", function () {

                it("should not iterate if called", function () {
                    none().flatMap(function (v) {
                        fail();
                    });
                });
            });

            describe("when map on none", function () {

                it("should not iterate if called", function () {
                    none().map(function (v) {
                        fail();
                    });
                });
            });

            describe("when orElse on none", function () {

                it("should none value be some", function () {
                    expect(none().orElse(function () {
                        return some(true);
                    })).toBeType(funk.option.Some);
                });

                it("should none value be false", function () {
                    expect(none().orElse(
                        function () {
                            return some(false);
                        }).get()).toBeFalsy();
                });

                it("should none be equal to expected orElse call", function () {
                    var func = function () {
                        return some(false);
                    }
                    expect(func().equals(none().orElse(func))).toBeTruthy();
                });
            });

            describe("when equals on none", function () {

                it("none should equal none", function () {
                    expect(none().equals(none())).toBeTruthy();
                });

                it("some null should not equal none", function () {
                    expect(some(null).equals(none())).toBeFalsy();
                });

                it("some undefined should not equal none", function () {
                    expect(some(undefined).equals(none())).toBeFalsy();
                });
            });

            describe("when toString on none", function () {

                it("should none be None", function () {
                    expect(none().toString()).toEqual("None");
                });
            });

            describe("when product on some", function () {

                it("should have product arity of 0", function () {
                    expect(none().productArity()).toStrictlyEqual(0);
                });

                it("should have product prefix of None", function () {
                    expect(none().productPrefix()).toStrictlyEqual("None");
                });

                it("should throw RangeError for product element at 0", function () {
                    expect(
                        function () {
                            none().productElement(1)
                        }).toBeThrown(new funk.error.RangeError());
                });
            });
        });
    });
});