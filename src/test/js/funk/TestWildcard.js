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

            it("should _ decrementBy equal 1 using invoke", function () {
                expect(_.invoke('decrementBy', 1)(2)).toStrictlyEqual(1);
            });

            it("should _ decrementBy equal 2", function () {
                expect(_.decrementBy(2)(2)).toStrictlyEqual(0);
            });

            it("should _ decrementBy equal 2 using invoke", function () {
                expect(_.invoke('decrementBy', 2)(2)).toStrictlyEqual(0);
            });

            it("should _ decrementBy equal -1", function () {
                expect(_.decrementBy(3)(2)).toStrictlyEqual(-1);
            });

            it("should _ decrementBy equal -1 using invoke", function () {
                expect(_.invoke('decrementBy', 3)(2)).toStrictlyEqual(-1);
            });

            it("should _ decrementBy equal 3", function () {
                expect(_.decrementBy(-1)(2)).toStrictlyEqual(3);
            });

            it("should _ decrementBy equal 3 using invoke", function () {
                expect(_.invoke('decrementBy', -1)(2)).toStrictlyEqual(3);
            });
        });

        describe("when _ divideBy", function () {

            it("should _ divideBy equal 1", function () {
                range.until(1, 10).foreach(function(i){
                    expect(_.divideBy(i)(i)).toBeStrictlyEqualTo(1);
                });
            });

            it("should _ divideBy equal 1 using invoke", function () {
                range.until(1, 10).foreach(function(i){
                    expect(_.invoke('divideBy', i)(i)).toBeStrictlyEqualTo(1);
                });
            });

            it("should _ divideBy -3, 3 equal -1", function(){
                expect(_.divideBy(-3)(3)).toBeStrictlyEqualTo(-1);
            });

            it("should _ divideBy -3, 3 equal -1 using invoke", function(){
                expect(_.invoke('divideBy', -3)(3)).toBeStrictlyEqualTo(-1);
            });

            it("should _ divideBy 2, 5 equal 2.5", function(){
                expect(_.divideBy(2)(5)).toBeStrictlyEqualTo(2.5);
            });

            it("should _ divideBy 2, 5 equal 2.5 using invoke", function(){
                expect(_.invoke('divideBy', 2)(5)).toBeStrictlyEqualTo(2.5);
            });
        });

        describe("when _ equals", function () {

            it("should _ equals does not equal {}", function () {
                expect(_.equals({})({})).toBeFalsy();
            });

            it("should _ equals does not equal {} using invoke", function () {
                expect(_.invoke('equals', {})({})).toBeFalsy();
            });

            it("should _ equals a equal b", function () {
                var a = 1;
                var b = 1;
                expect(_.equals(a)(b)).toBeTruthy();
            });

            it("should _ equals a equal b using invoke", function () {
                var a = 1;
                var b = 1;
                expect(_.invoke('equals', a)(b)).toBeTruthy();
            });

            it("should _ equals b equal a", function () {
                var a = 1;
                var b = 1;
                expect(_.equals(b)(a)).toBeTruthy();
            });

            it("should _ equals b equal a using invoke", function () {
                var a = 1;
                var b = 1;
                expect(_.invoke('equals', b)(a)).toBeTruthy();
            });

            it("should _ equals some(a) equal some(b)", function () {
                var a = some(1);
                var b = some(1);
                expect(_.equals(a)(b)).toBeTruthy();
            });

            it("should _ equals some(a) equal some(b) using invoke", function () {
                var a = some(1);
                var b = some(1);
                expect(_.invoke('equals', a)(b)).toBeTruthy();
            });

            it("should _ equals some(b) equal some(a)", function () {
                var a = some(1);
                var b = some(1);
                expect(_.equals(b)(a)).toBeTruthy();
            });

            it("should _ equals some(b) equal some(a) using invoke", function () {
                var a = some(1);
                var b = some(1);
                expect(_.invoke('equals', b)(a)).toBeTruthy();
            });
        });

        describe("when _ get", function () {

            it("should _ get property equals 1", function () {
                var a = {property: 1};
                expect(_.get("property")(a)).toBeStrictlyEqualTo(1);
            });

            it("should _ get property equals 1 using invoke", function () {
                var a = {property: 1};
                expect(_.invoke("get", "property")(a)).toBeStrictlyEqualTo(1);
            });

            it("should _ get unknown equals 1", function () {
                var a = {property: 1};
                expect(_.get("unknown")(a)).toBeUndefined();
            });

            it("should _ get unknown equals 1 using invoke", function () {
                var a = {property: 1};
                expect(_.invoke("get", "unknown")(a)).toBeUndefined();
            });
        });
    });
});