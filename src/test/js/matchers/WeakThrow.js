beforeEach(function(){
    this.addMatchers({
        /**
         * Check if an error is thrown, but don't check the message of the error, because it's dynamic.
         *
         * @param expected
         * @return True of thrown correctly
         */
        toBeThrown: function(expected){
            var result = false;
            var exception;
            if (typeof this.actual != 'function') {
                throw new Error('Actual is not a function');
            }
            try {
                this.actual();
            } catch (e) {
                exception = e;
            }
            if (exception) {
                result = (expected === jasmine.undefined || this.env.equals_(exception, expected));
                if(!result) {
                    if( "undefined" !== typeof exception &&
                        "undefined" !== typeof expected &&
                        exception.constructor === expected.constructor) {
                        result = true;
                    }
                }
            }

            var not = this.isNot ? "not " : "";

            this.message = function() {
                if (exception && (expected === jasmine.undefined || !this.env.equals_(exception, expected))) {
                    return ["Expected function " + not + "to throw", expected ? expected : "an exception", ", but it threw", exception].join(' ');
                } else {
                    return "Expected function to throw an exception.";
                }
            };

            return result;
        }
    });
});