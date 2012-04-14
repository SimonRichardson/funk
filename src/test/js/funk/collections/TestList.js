describe("funk", function () {
    describe("collections", function () {
        describe("List", function () {
            it("should not be not empty", function () {
                expect(list(1).nonEmpty()).toBeTruthy();
            });
        });
    });
});