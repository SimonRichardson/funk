beforeEach(function(){
    this.addMatchers({
        toStrictlyEqual: function(expected){
            return this.actual === expected;
        },
        toBeStrictlyEqualTo: function(expected){
            return this.actual === expected;
        }
    });
});