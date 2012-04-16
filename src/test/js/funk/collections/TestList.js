describe("funk", function () {
    describe("collections", function () {
        describe("List", function () {

            describe("when contains", function () {

                it("should contain undefined", function () {
                    expect(list(undefined).contains(undefined)).toBeTruthy();
                });

                it("should contain some(2)", function () {
                    expect(range.to(1, 10).map(funk.closure(some)).contains(some(2))).toBeTruthy();
                });

                it("should not contain some(0)", function () {
                    expect(range.to(1, 10).map(funk.closure(some)).contains(some(0))).not.toBeTruthy();
                });

                it("should not contain none()", function () {
                    expect(range.to(1, 10).map(funk.closure(some)).contains(none())).not.toBeTruthy();
                });
            });

            describe("when count", function () {

                it("should have 5 even items", function () {
                    expect(list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10).count(_.isEven())).toBeStrictlyEqualTo(5);
                });

                it("should have 5 even items when calling invoke", function () {
                    expect(list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10).count(_.invoke('isEven'))).toBeStrictlyEqualTo(5);
                });

                it("should have 5 even items when calling Range.to", function () {
                    expect(range.to(1, 10).count(_.isEven())).toBeStrictlyEqualTo(5);
                });

                it("should have 5 even items when calling Range.to when calling invoke", function () {
                    expect(range.to(1, 10).count(_.invoke('isEven'))).toBeStrictlyEqualTo(5);
                });

                it("should have 0 items that are greater than 10 when calling Range.to", function () {
                    expect(range.to(1, 10).count(_.greaterThan(10))).toBeStrictlyEqualTo(0);
                });

                it("should have 0 items that are greater than 10 when calling Range.to when calling invoke", function () {
                    expect(range.to(1, 10).count(_.invoke('greaterThan', 10))).toBeStrictlyEqualTo(0);
                });
            });

            describe("when non empty", function () {

                it("should (1) be non empty", function () {
                    expect(list(1).nonEmpty()).toBeTruthy();
                });

                it("should (1, 2) be non empty", function () {
                    expect(list(1, 2).nonEmpty()).toBeTruthy();
                });

                it("should be empty", function () {
                    expect(list().nonEmpty()).not.toBeTruthy();
                });
            });

            describe("when drop", function () {

                it("should throw argument error if passing -1", function () {
                    expect(funk.closure(list(1, 2).drop, -1)).toBeThrown(new funk.error.ArgumentError());
                });

                it("should drop first 2 values", function () {
                    expect(list(1, 1, 2).drop(2).head().get()).toBeStrictlyEqualTo(2);
                });

                it("should drop 2 leaving nil", function () {
                    expect(list(1, 2).drop(2)).toBeStrictlyEqualTo(nil());
                });

                it("should list(3, 4) should equal list(1, 2, 3, 4).drop(2)", function () {
                    expect(list(3, 4).equals(list(1, 2, 3, 4).drop(2))).toBeTruthy();
                });

                it("should be equal to itself after drop(0)", function () {
                    var value = list(1, 2, 3);
                    expect(value.drop(0)).toBeStrictlyEqualTo(value);
                });
            });

            describe("when dropRight", function () {

                it("should throw argument error if passing -1", function () {
                    expect(funk.closure(list(1, 2).dropRight, -1)).toBeThrown(new funk.error.ArgumentError());
                });

                it("should drop last 2 values", function () {
                    expect(list(1, 2, 2).dropRight(2).head().get()).toBeStrictlyEqualTo(1);
                });

                it("should drop 2 leaving nil", function () {
                    expect(list(1, 2).dropRight(2)).toBeStrictlyEqualTo(nil());
                });

                it("should list(1, 2) should equal list(1, 2, 3, 4).dropRight(2)", function () {
                    expect(list(1, 2).equals(list(1, 2, 3, 4).dropRight(2))).toBeTruthy();
                });

                it("should be equal to itself after drop(0)", function () {
                    var value = list(1, 2, 3);
                    expect(value.dropRight(0)).toBeStrictlyEqualTo(value);
                });
            });

            describe("when dropWhile", function () {

                it("should drop all contents", function () {
                    expect(list(1, 2, 3, 4).dropWhile(mapTrue)).toBeStrictlyEqualTo(nil());
                });

                it("should not drop any contents and should equal itself", function () {
                    var value = list(1, 2, 3, 4);
                    expect(value.dropWhile(mapFalse)).toBeStrictlyEqualTo(value);
                });

                it("should drop even until odd", function () {
                    expect(list(2, 4, 6, 1).dropWhile(mapEven).size()).toBeStrictlyEqualTo(1);
                });
            });

            describe("when exists", function () {

                it("should 1 exist", function () {
                    expect(list(1).exists(mapTrue)).toBeTruthy();
                });
            });
        });
    });
});