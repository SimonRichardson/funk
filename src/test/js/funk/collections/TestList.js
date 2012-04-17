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
                });
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

                it("should foldLeft example 2 with plus_", function () {
                    var n = 100;
                    expect(range.to(1, n + 1).foldLeft(0, _.plus_)).toBeEqualTo((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should foldLeft example 2 with invoke plus_", function () {
                    var n = 100;
                    expect(range.to(1, n + 1).foldLeft(0, _.invoke("plus_"))).toBeEqualTo((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should foldLeft string with map", function () {
                    expect(toList("TEST").map(_.toLowerCase).foldLeft("#", _.plus_)).toBeEqualTo("#" + "TEST".toLowerCase());
                });

                it("should foldLeft string with invoke map", function () {
                    expect(toList("TEST").map(_.invoke("toLowerCase")).foldLeft("#", _.invoke("plus_"))).toBeEqualTo("#" + "TEST".toLowerCase());
                });
            });

            describe("when foldRight", function () {

                it("should foldRight with plus_", function () {
                    var n = 100;
                    expect(range.to(1, n).foldRight(0, _.plus_)).toBeEqualTo(n * (n + 1) / 2);
                });

                it("should foldRight with invoke plus_", function () {
                    var n = 100;
                    expect(range.to(1, n).foldRight(0, _.invoke("plus_"))).toBeEqualTo(n * (n + 1) / 2);
                });

                it("should foldRight example 2 with plus_", function () {
                    var n = 100;
                    expect(range.to(1, n + 1).foldRight(0, _.plus_)).toBeEqualTo((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should foldRight example 2 with invoke plus_", function () {
                    var n = 100;
                    expect(range.to(1, n + 1).foldRight(0, _.invoke("plus_"))).toBeEqualTo((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should foldRight string with map", function () {
                    expect(toList("tset").map(_.toUpperCase).foldRight("#", _.plus_)).toBeEqualTo("#" + "test".toUpperCase());
                });

                it("should foldRight string with invoke map", function () {
                    expect(toList("tset").map(_.invoke("toUpperCase")).foldRight("#", _.invoke("plus_"))).toBeEqualTo("#" + "test".toUpperCase());
                });
            });

            describe("when forall", function () {

                it("should be true", function () {
                    expect(range.to(1, 10).forall(mapTrue)).toBeTruthy();
                });

                it("should be false", function () {
                    expect(range.to(1, 10).forall(mapFalse)).toBeFalsy();
                });

                it("should all be less than 11", function () {
                    expect(range.to(1, 10).forall(_.lessThan(11))).toBeTruthy();
                });

                it("should invoke less than 11", function () {
                    expect(range.to(1, 10).forall(_.invoke("lessThan", 11))).toBeTruthy();
                });

                it("should all be less than 10", function () {
                    expect(range.to(1, 10).forall(_.lessThan(10))).toBeFalsy();
                });

                it("should invoke less than 10", function () {
                    expect(range.to(1, 10).forall(_.invoke("lessThan", 10))).toBeFalsy();
                });
            });

            describe("when foreach", function () {

                it("should equal 10", function(){
                    var total = 10;
                    var i = 0;

                    range.until(0, total).foreach(function(x){
                        expect(i++).toBeStrictlyEqualTo(when(x, {
                            none: function(){
                                fail();
                            },
                            some: function(value){
                                return value;
                            }
                        }));
                    });

                    expect(i).toBeStrictlyEqualTo(total);
                })
            });

            describe("when get", function () {

                it("should match range", function(){
                    expect(range.until(0, 10).equals(range.until(0, 10))).toBeTruthy();
                })
            });

            describe("when head", function () {

                it("should be some", function(){
                    expect(list(1).head()).toBeType(funk.option.Some);
                });

                it("should not be none", function(){
                    expect(list(1).head()).not.toBeType(funk.option.None);
                });

                it("should {} match head", function(){
                    var value = {};
                    expect(list(value, 2, 3).head().get()).toBeStrictlyEqualTo(value);
                });

                it("should 1 match head", function(){
                    expect(list(1, 2, 3).head().get()).toBeStrictlyEqualTo(1);
                });

                it("should null match head", function(){
                    expect(list(null, 2, 3).head().get()).toBeNull();
                });

                it("should undefined match head", function(){
                    expect(list(undefined, 2, 3).head().get()).toBeUndefined();
                });
            });

            describe("when indexOf", function () {

                it("should 0 be 0 of 1..10", function(){
                    expect(range.to(0, 10).indexOf(0)).toBeStrictlyEqualTo(0);
                });

                it("should 9 be 9 of 1..10", function(){
                    expect(range.to(0, 10).indexOf(9)).toBeStrictlyEqualTo(9);
                });

                it("should 4 be 4 of 1..10", function(){
                    expect(range.to(0, 10).indexOf(4)).toBeStrictlyEqualTo(4);
                });

                it("should 11 be -1 of 1..10", function(){
                    expect(range.to(0, 10).indexOf(11)).toBeStrictlyEqualTo(-1);
                });
            });

            describe("when indices", function () {

                it("should equal 0..4", function(){
                    var value = "Hello";
                    expect(range.until(0, value.length).equals(toList(value).indices())).toBeTruthy();
                });
            });

            describe("when init", function () {

                it("should be size minus one", function(){
                    var l = list(1, 2, 3);
                    expect(l.init().size()).toBeStrictlyEqualTo(l.size() - 1);
                });

                it("should make test equal tes", function(){
                    expect(toList("test").init().reduceLeft(_.plus_)).toBeStrictlyEqualTo("tes");
                });

                it("should make test equal tes using invoke", function(){
                    expect(toList("test").init().reduceLeft(_.invoke("plus_"))).toBeStrictlyEqualTo("tes");
                });
            });

            describe("when isEmpty", function () {

                it("should empty list be empty", function(){
                    expect(list().isEmpty()).toBeTruthy();
                });

                it("should non empty list be not empty", function(){
                    expect(list(1, 2, 3).isEmpty()).toBeFalsy();
                });

                it("should non empty list (undefined) be not empty", function(){
                    expect(list(undefined).isEmpty()).toBeFalsy();
                });

                it("should non empty list (null) be not empty", function(){
                    expect(list(null).isEmpty()).toBeFalsy();
                });
            });

            describe("when last", function () {

                it("should be last item", function(){
                    expect(toList("test$").last().get()).toBeStrictlyEqualTo("$");
                });
            });

            describe("when partitioning", function () {

                var l,
                    p;

                beforeEach(function(){
                    l = range.to(1, 10);
                    p = l.partition(_.isEven);
                });

                it("should tuple at index 1 should be a list", function(){
                    expect(funk.util.verifiedType(p._1(), funk.collection.List)).toBeStrictlyEqualTo(p._1());
                });

                it("should tuple at index 2 should be a list", function(){
                    expect(funk.util.verifiedType(p._2(), funk.collection.List)).toBeStrictlyEqualTo(p._2());
                });

                it("should tuple at index 1 be size of 5", function(){
                    expect(p._1().size()).toBeStrictlyEqualTo(5);
                });

                it("should tuple at index 2 be size of 5", function(){
                    expect(p._2().size()).toBeStrictlyEqualTo(5);
                });

                it("should tuple at index 1 when filter using isEven should equal itself", function(){
                    expect(p._1().filter(_.isEven)).toBeStrictlyEqualTo(p._1());
                });

                it("should tuple at index 2 when filterNot using isEven should equal itself", function(){
                    expect(p._2().filterNot(_.isEven)).toBeStrictlyEqualTo(p._2());
                });
            });

            describe("when prepending", function () {

                it("should start with nil, but equal one when adding {}", function(){
                    expect(nil().prepend({}).size()).toBeStrictlyEqualTo(1);
                });

                it("should start with nil, but equal one when adding null", function(){
                    expect(nil().prepend(null).size()).toBeStrictlyEqualTo(1);
                });

                it("should start with nil, but equal one when adding undefined", function(){
                    expect(nil().prepend(undefined).size()).toBeStrictlyEqualTo(1);
                });

                it("should equal value when prepending", function(){
                    var value = {};
                    expect(nil().prepend(value).get(0).get()).toBeStrictlyEqualTo(value);
                });
            });

            describe("when prepending all", function () {

                it("should prepend all", function(){
                    var l = list({}, {}, {});
                    expect(nil().prependAll(l).size()).toBeStrictlyEqualTo(l.size());
                });

                it("should prepend all", function(){
                    var l = list({}, {}, {});
                    for(var i = 0, n = l.size; i < n; ++i) {
                        expect(nil().prependAll(l).get(i).equals(l.get(i))).toBeTruthy();
                    }
                })

                it("should not prepend all with nil", function(){
                    expect(nil().prependAll(nil()).size()).toBeStrictlyEqualTo(0);
                });

                it("should equal nil when prepend all with nil", function(){
                    expect(nil().prependAll(nil())).toBeStrictlyEqualTo(nil());
                });
            });

            describe("when reduceLeft", function () {

                it("should reduceLeft with plus", function(){
                    var n = 100;
                    expect(range.to(1, n).reduceLeft(_.plus_)).toStrictlyEqual(n * (n + 1) / 2);
                });

                it("should reduceLeft with invoke plus", function(){
                    var n = 100;
                    expect(range.to(1, n).reduceLeft(_.invoke("plus_"))).toStrictlyEqual(n * (n + 1) / 2);
                });

                it("should reduceLeft example 2 with plus", function(){
                    var n = 100;
                    expect(range.to(1, n + 1).reduceLeft(_.plus_)).toStrictlyEqual((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should reduceLeft example 2 with invoke plus", function(){
                    var n = 100;
                    expect(range.to(1, n + 1).reduceLeft(_.invoke("plus_"))).toStrictlyEqual((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should reduceLeft with toLowerCase", function(){
                    var n = 100;
                    expect(toList("TEST").map(_.toLowerCase).reduceLeft(_.plus_)).toStrictlyEqual("TEST".toLowerCase());
                });

                it("should reduceLeft example 2 with invoke plus", function(){
                    var n = 100;
                    expect(toList("TEST").map(_.invoke("toLowerCase")).reduceLeft(_.invoke("plus_"))).toStrictlyEqual("TEST".toLowerCase());
                });
            });

            describe("when reduceRight", function () {

                it("should reduceRight with plus", function(){
                    var n = 100;
                    expect(range.to(1, n).reduceRight(_.plus_)).toStrictlyEqual(n * (n + 1) / 2);
                });

                it("should reduceRight with invoke plus", function(){
                    var n = 100;
                    expect(range.to(1, n).reduceRight(_.invoke("plus_"))).toStrictlyEqual(n * (n + 1) / 2);
                });

                it("should reduceRight example 2 with plus", function(){
                    var n = 100;
                    expect(range.to(1, n + 1).reduceRight(_.plus_)).toStrictlyEqual((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should reduceRight example 2 with invoke plus", function(){
                    var n = 100;
                    expect(range.to(1, n + 1).reduceRight(_.invoke("plus_"))).toStrictlyEqual((n + 1) * ((n + 1) + 1) / 2);
                });

                it("should reduceRight with toLowerCase", function(){
                    var n = 100;
                    expect(toList("tset").map(_.toUpperCase).reduceRight(_.plus_)).toStrictlyEqual("test".toUpperCase());
                });

                it("should reduceRight example 2 with invoke plus", function(){
                    var n = 100;
                    expect(toList("tset").map(_.invoke("toUpperCase")).reduceRight(_.invoke("plus_"))).toStrictlyEqual("test".toUpperCase());
                });
            });

            describe("when reverse", function () {

                it("should reverse string \"hello world\"", function(){
                    expect(toList("hello world").reverse().equals(toList("dlrow olleh"))).toBeTruthy();
                });

                it("should reverse string 1, 2, 3, 4, 5", function(){
                    expect(list(1, 2, 3, 4, 5).reverse().equals(list(5, 4, 3, 2, 1))).toBeTruthy();
                });
            });

            describe("when tail", function () {

                it("should be nil for one item", function(){
                    expect(list(1).tail().equals(nil())).toBeFalsy();
                });

                it("should be some(nil) for one item", function(){
                    expect(list(1).tail().equals(some(nil()))).toBeTruthy();
                });
            });

            describe("when take", function () {

                it("should throw", function(){
                    expect(function(){
                        list(1).take(-1)
                    }).toBeThrown(new funk.error.ArgumentError());
                });

                it("should take the first item and should be true", function(){
                    expect(list(true).take(1).head().get()).toBeTruthy();
                });

                it("should take the first item and should equal some(true)", function(){
                    expect(list(true).take(1).head().equals(some(true))).toBeTruthy();
                });

                it("should take 2 items should equal true, false", function(){
                    expect(list(true, false, false, false).take(2).equals(list(true, false))).toBeTruthy();
                });
            });

            describe("when takeRight", function () {

                it("should throw", function(){
                    expect(function(){
                        list(1).takeRight(-1)
                    }).toBeThrown(new funk.error.ArgumentError());
                });

                it("should take the first item and should be true", function(){
                    expect(list(true).takeRight(1).head().get()).toBeTruthy();
                });

                it("should take the first item and should equal some(true)", function(){
                    expect(list(true).takeRight(1).head().equals(some(true))).toBeTruthy();
                });

                it("should take 2 items should equal true, false", function(){
                    expect(list(false, false, true, false).takeRight(2).equals(list(true, false))).toBeTruthy();
                });
            });

            describe("when takeWhile", function () {

                it("should take all the items", function(){
                    expect(list(true, true, true).takeWhile(mapTrue).equals(list(true, true, true))).toBeTruthy();
                });

                it("should take none of the items", function(){
                    expect(list(true, true, true).takeWhile(mapFalse).equals(nil())).toBeTruthy();
                });
            });

            describe("when zip", function () {

                it("should zip to lists together that are same size", function(){
                    expect(range.to(1, 3).zip(range.to(1, 3)).equals(list(tuple2(1, 1), tuple2(2, 2), tuple2(3, 3)))).toBeTruthy();
                });

                it("should zip to lists together using the smallest size", function(){
                    expect(range.to(1, 4).zip(range.to(1, 3)).equals(list(tuple2(1, 1), tuple2(2, 2), tuple2(3, 3)))).toBeTruthy();
                });

                it("should zip to lists together using the smallest size 2", function(){
                    expect(range.to(1, 3).zip(range.to(1, 4)).equals(list(tuple2(1, 1), tuple2(2, 2), tuple2(3, 3)))).toBeTruthy();
                });
            });

            describe("when zipWithIndex", function () {

                it("should zip to lists together with the index", function(){
                    expect(range.to(1, 3).zipWithIndex().equals(list(tuple2(1, 0), tuple2(2, 1), tuple2(3, 2)))).toBeTruthy();
                });
            });

            describe("when product on list", function () {

                it("should have product arity of 10", function () {
                    expect(range.to(1, 10).productArity()).toStrictlyEqual(10);
                });

                it("should have product arity same as size", function () {
                    expect(range.to(1, 10).productArity()).toStrictlyEqual(range.to(1, 10).size());
                });

                it("should have product prefix of List", function () {
                    expect(list(null).productPrefix()).toStrictlyEqual("List");
                });

                it("should throw RangeError for product element at -1", function () {
                    expect(
                        function () {
                            list(null).productElement(-1)
                        }).toBeThrown(new funk.error.RangeError());
                });

                it("should throw RangeError for product element at 1", function () {
                    expect(
                        function () {
                            list(null).productElement(1)
                        }).toBeThrown(new funk.error.RangeError());
                });

                it("should get value at productElement 0", function () {
                    var value = {};
                    expect(list(value).productElement(0).get()).toBeStrictlyEqualTo(value);
                });
            });

            describe("when equals", function () {

                it("should list(undefined) equal list(undefined)", function(){
                    expect(list(undefined).equals(list(undefined))).toBeTruthy();
                });

                it("should list(null) equal list(null)", function(){
                    expect(list(null).equals(list(null))).toBeTruthy();
                });

                it("should list(null) equal list(null)", function(){
                    expect(list({}).equals(list({}))).toBeFalsy();
                });

                it("should list(value) equal list(value)", function(){
                    var value = {};
                    expect(list(value).equals(list(value))).toBeTruthy();
                });

                it("should list() equal list()", function(){
                    expect(list().equals(list())).toBeTruthy();
                });

                it("should list() equal list(1).tail()", function(){
                    expect(list().equals(list(1).tail())).toBeTruthy();
                });
            });

            describe("when size", function () {

                it("should have 0 size on an empty list", function(){
                    expect(list().size()).toStrictlyEqual(0);
                });

                it("should have size 10 on range 0...10", function(){
                    var n = 10;
                    expect(range.to(1, n).size()).toStrictlyEqual(n);
                });
            });

            describe("when hasDefinedSize", function () {

                it("should have defined size on an empty list", function(){
                    expect(list().hasDefinedSize()).toBeTruthy();
                });

                it("should have defined size on a non empty list", function(){
                    var n = 10;
                    expect(range.to(1, n).hasDefinedSize()).toBeTruthy();
                });
            });

            describe("when toArray", function () {

                it("should should have length of 0", function(){
                    expect(list().toArray().length).toBeStrictlyEqualTo(0);
                });

                it("should should have length of 10", function(){
                    var n = 10;
                    expect(range.to(1, n).toArray().length).toBeStrictlyEqualTo(n);
                });

                it("should should have item [0] to be 1", function(){
                    expect(list(1, 2, 3).toArray()[0].get()).toBeStrictlyEqualTo(1);
                });

                it("should should have item [1] to be 2", function(){
                    expect(list(1, 2, 3).toArray()[1].get()).toBeStrictlyEqualTo(2);
                });

                it("should should have item [3] to be 3", function(){
                    expect(list(1, 2, 3).toArray()[2].get()).toBeStrictlyEqualTo(3);
                });
            });

            describe("when append", function () {

                it("should append 3 to list 1, 2", function(){
                    expect(list(1, 2).append(3).equals(list(1, 2, 3))).toBeTruthy();
                });

                it("should append nil() to list 1, 2", function(){
                    expect(list(1, 2).append(nil()).equals(list(1, 2, nil()))).toBeTruthy();
                });
            });

            describe("when appendAll", function () {

                it("should append 1, 2, 3 to list 4, 5, 6", function(){
                    expect(list(1, 2, 3).appendAll(list(4, 5, 6)).equals(list(1, 2, 3, 4, 5, 6))).toBeTruthy();
                });

                it("should append nil() to list 1, 2, 3", function(){
                    expect(list(1, 2, 3).appendAll(nil()).equals(list(1, 2, 3))).toBeTruthy();
                });
            });
        });
    });
});