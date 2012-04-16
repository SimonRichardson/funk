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
                    expect(list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10).count(_.isEven)).toBeStrictlyEqualTo(5);
                });

                it("should have 5 even items when calling invoke", function () {
                    expect(list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10).count(_.invoke('isEven'))).toBeStrictlyEqualTo(5);
                });

                it("should have 5 even items when calling Range.to", function () {
                    expect(range.to(1, 10).count(_.isEven)).toBeStrictlyEqualTo(5);
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

                it("should have 5 items that are greater than 10 when calling Range.to when calling invoke", function () {
                    expect(range.to(1, 10).count(_.invoke('greaterThan', 5))).toBeStrictlyEqualTo(5);
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

                it("should be true when maps true", function () {
                    expect(list(1).exists(mapTrue)).toBeTruthy();
                });

                it("should be true when 5 is in range of 0...10", function () {
                    expect(range.to(1, 10).exists(_.equals(5))).toBeTruthy();
                });

                it("should be false when 0 is in range of 0...10", function () {
                    expect(range.to(1, 10).exists(_.equals(0))).not.toBeTruthy();
                });
            });

            describe("when filter", function () {

                it("should be true when maps true", function () {
                    var l = list(1, 2, 3);
                    expect(l.filter(mapTrue)).toBeStrictlyEqualTo(l);
                });

                it("should filter even items", function () {
                    expect(list(2, 4, 6, 8, 10).equals(range.to(1, 10).filter(_.isEven))).toBeTruthy();
                });

                it("should not equal filter even items", function () {
                    expect(list(1, 4, 6, 8, 10).equals(range.to(1, 10).filter(_.isEven))).toBeFalsy();
                });
            });

            describe("when filterNot", function () {

                it("should filter out to have the correct size", function () {
                    var l = list(1, 2, 1, 2);
                    expect(l.filterNot(_.equals(some(2))).size()).toBeStrictlyEqualTo(l.size() - 2);
                });

                it("should not filter out to have the correct size", function () {
                    var l = list(1, 2, 1, 2);
                    expect(l.filterNot(mapFalse).size()).toBeStrictlyEqualTo(l.size());
                });

                it("should filter all to have the correct size", function () {
                    var l = list(1, 2, 1, 2);
                    expect(l.filterNot(mapTrue).size()).toBeStrictlyEqualTo(0);
                });

                it("should filter all", function () {
                    var l = list(1, 2, 1, 2);
                    expect(l.filterNot(mapTrue)).toBeStrictlyEqualTo(nil());
                });
            });

            describe("when find", function () {

                it("should find some(2) in range 1...10", function () {
                    expect(some(2).equals(range.to(1, 10).map(funk.closure(some)).find(_.equals(some(2))))).toBeTruthy();
                });

                it("should find some(some(2)) in range 1...10", function () {
                    expect(some(some(2)).equals(range.to(1, 10).map(funk.closure(some)).find(_.equals(some(2))))).toBeTruthy();
                });

                it("should find not find 11 in range 1...10", function(){
                    expect(range.to(1, 10).map(funk.closure(some)).find(_.equals(11))).toBeStrictlyEqualTo(none());
                });

                it("should find not find some(11) in range 1...10", function(){
                    expect(range.to(1, 10).map(funk.closure(some)).find(_.equals(some(11)))).toBeStrictlyEqualTo(none());
                });

                it("should find not find none() in range 1...10", function(){
                    expect(range.to(1, 10).map(funk.closure(some)).find(_.equals(none()))).toBeStrictlyEqualTo(none());
                });
            });

            describe("when findIndexOf", function () {

                it("should find index of 3", function () {
                    expect(range.to(1, 4).findIndexOf(_.equals(3))).toBeStrictlyEqualTo(2);
                });

                it("should not find index of 5", function () {
                    expect(range.to(1, 4).findIndexOf(_.equals(5))).toBeStrictlyEqualTo(-1);
                });
            });

            describe("when flatMap", function () {

                it("should match list after using to in flatMap", function () {
                    expect(list("a", "b", "c", "d").equals(list("a", "b", "c", "d").flatMap(toList))).toBeTruthy();
                });

                it("should remove 2 from list(1,2,3) after flatMap", function () {
                    expect(list(1, 3).equals(list(1, 2, 3).flatMap(function(x){
                        return eq(x, 2) ? nil() : list(x);
                    }))).toBeTruthy();
                });

                it("should throw an error when return invalid result", function(){
                    expect(function(){
                        list(1, 2, 3).flatMap(function(){
                            return {};
                        });
                    }).toBeThrown(new funk.error.TypeError());
                })
            });

            describe("when flatten", function () {

                it("should match list after flattening", function () {
                    expect(list(list(1), nil(), list(2), nil(), nil(), list(3)).flatten().equals(range.to(1, 3))).toBeTruthy();
                });
            });

            describe("when foldLeft", function () {

                it("should foldLeft with plus_", function () {
                    var n = 100;
                    expect(range.to(1, n).foldLeft(0, _.plus_)).toBeEqualTo(n * (n + 1) / 2);
                });

                it("should foldLeft with invoke plus_", function () {
                    var n = 100;
                    expect(range.to(1, n).foldLeft(0, _.invoke("plus_"))).toBeEqualTo(n * (n + 1) / 2);
                });
            });

        });
    });
});