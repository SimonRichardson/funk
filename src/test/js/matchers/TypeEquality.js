beforeEach(function(){
    this.addMatchers({
        toBeType: function(expected){
            return this.actual === funk.util.verifiedType(this.actual, expected);
        }
    });
});