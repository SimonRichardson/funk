describe("funk", function () {
    describe("collections", function () {
        describe("Nil", function () {
            it("should not be not empty", function () {
                expect(nil().nonEmpty()).toBeFalsy();
            });

            it("should be empty", function () {
                expect(nil().isEmpty()).toBeTruthy();
            });

            it("should have zero size", function () {
                expect(nil().size()).toStrictlyEqual(0);
            });

            it("should have a defined size", function () {
                expect(nil().hasDefinedSize()).toBeTruthy();
            });

            describe("when contains on nil", function () {

                it("should not contain null", function () {
                    expect(nil().contains(null)).toBeFalsy();
                });

                it("should not contain undefined", function () {
                    expect(nil().contains(undefined)).toBeFalsy();
                });

                it("should not contain true", function () {
                    expect(nil().contains(true)).toBeFalsy();
                });

                it("should not contain {}", function () {
                    expect(nil().contains({})).toBeFalsy();
                });
            });

            describe("when toArray on nil", function () {

                it("should not be null", function () {
                    expect(nil().toArray()).not.toBeNull();
                });

                it("should be type of array", function () {
                    expect(nil().toArray()).toBeType(Array);
                });

                it("should be an empty array", function () {
                    expect(nil().toArray().length).toStrictlyEqual(0);
                });
            });

            describe("when product on some", function () {

                it("should have product arity of 0", function () {
                    expect(nil().productArity()).toStrictlyEqual(0);
                });

                it("should have product prefix of List", function () {
                    expect(nil().productPrefix()).toStrictlyEqual("List");
                });

                it("should throw RangeError for product element at 0", function () {
                    expect(
                        function () {
                            nil().productElement(1)
                        }).toThrow(new funk.error.RangeError());
                });
            });
        });
    });
});