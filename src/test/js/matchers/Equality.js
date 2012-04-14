beforeEach(function(){
    this.addMatchers({
        toBeEqualTo: function(expected){
            return this.actual == expected;
        }
    });
});