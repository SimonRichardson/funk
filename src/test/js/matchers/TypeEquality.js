beforeEach(function(){
    this.addMatchers({
        toBeType: function(expected){
            return this.actual instanceof expected;
        }
    });
});