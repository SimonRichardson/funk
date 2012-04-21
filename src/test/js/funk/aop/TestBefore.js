describe("funk", function(){
    describe("aop", function(){
        describe("before", function(){

            it("example", function(){
                before(String, 'toString', function(method, args){
                    console.log("Hello", method, args);
                });
                "Stuff".toString();
            });
        });
    });
});