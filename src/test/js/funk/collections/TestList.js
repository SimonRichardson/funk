describe("funk", function () {
    describe("collections", function () {
        describe("List", function () {

            describe("when contains", function(){
                 it("should contain undefined", function(){
                     expect(list(undefined).contains(undefined)).toBeTruthy();
                 });
            });

            it("should not be not empty", function () {
                expect(list(1).nonEmpty()).toBeTruthy();
            });
        });
    });
});