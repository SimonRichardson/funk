funk.option = funk.option || {};
funk.option.when = function(option, cases){
    if(option === funk.util.verifiedType(option, funk.option.Option)) {
        if(option instanceof funk.option.None) {
            if(funk.has(cases, 'none')) {
                return cases.none();
            } else {
                throw new funk.error.NoSuchElementError('Expected none in cases');
            }
        } else if(option instanceof funk.option.Some) {
            if(funk.has(cases, 'some')) {
                return cases.some();
            } else {
                throw new funk.error.NoSuchElementError('Expected some in cases');
            }
        } else {
            if(funk.has(cases, 'any')) {
                return cases.any();
            } else {
                throw new funk.error.TypeError("Expected: funk.option.Option, Actual: " + option);
            }
        }
    }
};

// Alias
var when = funk.option.when;