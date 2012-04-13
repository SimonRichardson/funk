describe("funk", function () {
    describe("Wildcard", function () {
        "use strict";

        it("should _ binaryNot equal ~1234", function () {
            expect(_.binaryNot(1234)).toStrictlyEqual(~1234);
        });

        describe("when _ decrementBy", function () {

            it("should _ decrementBy equal 1", function () {
                expect(_.decrementBy(1)(2)).toStrictlyEqual(1);
            });

            it("should _ decrementBy equal 2", function () {
                expect(_.decrementBy(2)(2)).toStrictlyEqual(0);
            });

            it("should _ decrementBy equal -1", function () {
                expect(_.decrementBy(3)(2)).toStrictlyEqual(-1);
            });

            it("should _ decrementBy equal 3", function () {
                expect(_.decrementBy(-1)(2)).toStrictlyEqual(3);
            });
        });

    });
});