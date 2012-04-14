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

            it("should not call count", function(){
                nil().count(function(){
                    fail();
                });
            });

            describe("when drop on nil", function(){

                it("should return nil when calling drop", function(){
                    expect(nil().drop(0)).toBeStrictlyEqualTo(nil());
                });

                it("should throw argument error when passing -1 to drop", function(){
                    expect(funk.closure(nil().drop, -1)).toThrow(new funk.error.ArgumentError("index must be positive."));
                });

                it("should return nil when calling dropRight", function(){
                    expect(nil().dropRight(0)).toBeStrictlyEqualTo(nil());
                });

                it("should throw argument error when passing -1 to dropRight", function(){
                    expect(funk.closure(nil().dropRight, -1)).toThrow(new funk.error.ArgumentError("index must be positive."));
                });

                it("should return nil when calling mapTrue on dropWhile", function(){
                    expect(nil().dropWhile(mapTrue)).toBeStrictlyEqualTo(nil());
                });

                it("should not throw an error when calling dropWhile on nil", function(){
                    expect(nil().dropWhile(function(){
                        fail();
                    })).toBeStrictlyEqualTo(nil());
                });
            });

            describe("when exits on nil", function() {

                it("should return false when calling mapTrue on exists", function(){
                    expect(nil().exists(mapTrue)).toBeFalsy();
                });

                it("should not throw an error when calling exists on nil", function(){
                    expect(nil().exists(function(){
                        fail();
                    })).toBeFalsy();
                });
            });

            describe("when filter on nil", function() {

                it("should return nil when calling mapFalse on filter", function(){
                    expect(nil().filter(mapFalse)).toBeStrictlyEqualTo(nil());
                });

                it("should not throw an error when calling filter on nil", function(){
                    expect(nil().filter(function(){
                        fail();
                    })).toBeStrictlyEqualTo(nil())
                });
            });

            describe("when filterNot on nil", function() {

                it("should return nil when calling mapFalse on filterNot", function(){
                    expect(nil().filterNot(mapFalse)).toBeStrictlyEqualTo(nil());
                });

                it("should not throw an error when calling filterNot on nil", function(){
                    expect(nil().filterNot(function(){
                        fail();
                    })).toBeStrictlyEqualTo(nil())
                });
            });

            describe("when find on nil", function() {

                it("should return nil when calling mapTrue on find", function(){
                    expect(nil().find(mapTrue)).toBeStrictlyEqualTo(none());
                });

                it("should not throw an error when calling find on nil", function(){
                    expect(nil().find(function(){
                        fail();
                    })).toBeStrictlyEqualTo(none())
                });
            });

            describe("when findIndexOf on nil", function() {

                it("should return -1 when calling mapTrue on findIndexOf", function(){
                    expect(nil().findIndexOf(mapTrue)).toBeStrictlyEqualTo(-1);
                });

                it("should not throw an error when calling findIndexOf on nil", function(){
                    expect(nil().findIndexOf(function(){
                        fail();
                    })).toBeStrictlyEqualTo(-1)
                });
            });

            describe("when flatMap on nil", function() {

                it("should return nil when calling indentity on flatMap", function(){
                    expect(nil().flatMap(indentity)).toBeStrictlyEqualTo(nil());
                });

                it("should not throw an error when calling flatMap on nil", function(){
                    expect(nil().flatMap(function(){
                        fail();
                    })).toBeStrictlyEqualTo(nil())
                });
            });

            describe("when flatten on nil", function() {

                it("should return nil when calling flatten", function(){
                    expect(nil().flatten()).toBeStrictlyEqualTo(nil());
                });
            });

            describe("when fold on nil", function() {

                it("should return 0 when calling foldLeft", function(){
                    expect(nil().foldLeft(0, _.invoke("plus"))).toBeStrictlyEqualTo(0);
                });

                it("should not throw an error when calling foldLeft on nil", function(){
                    expect(nil().foldLeft(0, function(x, y){
                        fail();
                    })).toBeStrictlyEqualTo(0)
                });

                it("should return 0 when calling foldRight", function(){
                    expect(nil().foldRight(0, _.invoke("plus"))).toBeStrictlyEqualTo(0);
                });

                it("should not throw an error when calling foldRight on nil", function(){
                    expect(nil().foldRight(0, function(x, y){
                        fail();
                    })).toBeStrictlyEqualTo(0)
                });
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