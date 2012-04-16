describe("funk", function () {
    describe("option", function () {
        describe("When", function () {

            it("should throw an error if passing null", function(){
                expect(function(){
                    when(null, {
                        none: function(){
                            fail();
                        },
                        some: function(){
                            fail();
                        }
                    });
                }).toBeThrown(new funk.error.TypeError());
            });

            it("should throw an error if passing {}", function(){
                expect(function(){
                    when({}, {
                        none: function(){
                            fail();
                        },
                        some: function(){
                            fail();
                        }
                    });
                }).toBeThrown(new funk.error.TypeError());
            });

            describe("when calling none", function(){
                it("should return false when none", function(){
                    expect(when(none(), {
                        none: function(){
                            return false;
                        },
                        some: function(value){
                            fail();
                        }
                    })).toBeFalsy();
                });
            });

            describe("when calling some", function(){
                it("should return true", function(){
                    expect(when(some(true), {
                        none: function(){
                            fail();
                        },
                        some: function(value){
                            return true;
                        }
                    })).toBeTruthy();
                });

                it("should return the same value as passed in", function(){
                    var value = {};
                    expect(when(some(value), {
                        none: function(){
                            fail();
                        },
                        some: function(value){
                            return value;
                        }
                    })).toBeStrictlyEqualTo(value);
                });
            });

            describe("when calling default state (any)", function(){
                it("should return true", function(){
                    expect(when(some(true), {
                        any: function(){
                            return true;
                        }
                    })).toBeTruthy();
                });

                it("should return the same value as passed in", function(){
                    var value = {};
                    expect(when(some(value), {
                        any: function(value){
                            return value;
                        }
                    })).toBeStrictlyEqualTo(value);
                });

                it("should throw an error if passing null", function(){
                    expect(function(){
                        when(null, {
                            any: function(value){
                                fail();
                            }
                        });
                    }).toBeThrown(new funk.error.TypeError());
                });

                it("should throw an error if passing {}", function(){
                    expect(function(){
                        when({}, {
                            any: function(value){
                                fail();
                            }
                        });
                    }).toBeThrown(new funk.error.TypeError());
                });
            });
        });
    });
});
