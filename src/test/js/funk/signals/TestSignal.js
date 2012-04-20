describe("funk", function () {
    describe("Signal", function () {
        "use strict";

        describe("when adding value type", function(){
            it("should valueClasses not be null", function(){
                var signal = new funk.signals.Signal();
                expect(signal.valueClasses()).not.toBeNull();
            });

            it("should valueClasses not be undefined", function(){
                var signal = new funk.signals.Signal();
                expect(signal.valueClasses()).not.toBeUndefined();
            });

            it("should empty Signal have no value types", function(){
                var signal = new funk.signals.Signal();
                expect(signal.valueClasses().length).toBeStrictlyEqualTo(0);
            });

            it("should Signal have 1 value types", function(){
                var signal = new funk.signals.Signal(Object);
                expect(signal.valueClasses().length).toBeStrictlyEqualTo(1);
            });

            it("should Signal have 1 value type equal to Object", function(){
                var signal = new funk.signals.Signal(Object);
                expect(signal.valueClasses()[0]).toBeStrictlyEqualTo(Object);
            });

            it("should Signal have 2 value types", function(){
                var signal = new funk.signals.Signal(Object, String);
                expect(signal.valueClasses().length).toBeStrictlyEqualTo(2);
            });

            it("should Signal have 2 value type equal to Object, String", function(){
                var signal = new funk.signals.Signal(Object, String);
                expect(signal.valueClasses()[0]).toBeStrictlyEqualTo(Object);
                expect(signal.valueClasses()[1]).toBeStrictlyEqualTo(String);
            });
        });

        describe("when adding", function(){
            it("should have size of 0 when created", function(){
                var signal = new funk.signals.Signal();
                expect(signal.size()).toBeStrictlyEqualTo(0);
            });

            it("should throw an error if passing null to add", function(){
                var signal = new funk.signals.Signal();

                expect(function(){
                    signal.add(null);
                }).toBeThrown(new funk.error.ArgumentError());
            });

            it("should throw an error if passing undefined to add", function(){
                var signal = new funk.signals.Signal();

                expect(function(){
                    signal.add(undefined);
                }).toBeThrown(new funk.error.ArgumentError());
            });

            it("should throw an error if passing {} to add", function(){
                var signal = new funk.signals.Signal();

                expect(function(){
                    signal.add({});
                }).toBeThrown(new funk.error.ArgumentError());
            });

            it("should not throw an error when adding a function", function(){
                var signal = new funk.signals.Signal();

                expect(function(){
                    signal.add(function(){

                    });
                }).not.toBeThrown(new funk.error.ArgumentError());
            });

            it("should have size of 1 when adding a function", function(){
                var signal = new funk.signals.Signal();
                signal.add(function(){
                });
                expect(signal.size()).toBeStrictlyEqualTo(1);
            });

            it("should have size of 2 when adding a 2 functions", function(){
                var signal = new funk.signals.Signal();
                signal.add(function(){
                });
                signal.add(function(){
                });
                expect(signal.size()).toBeStrictlyEqualTo(2);
            });

            it("should have size of 3 when adding a 3 functions", function(){
                var signal = new funk.signals.Signal();
                signal.add(function(){
                });
                signal.add(function(){
                });
                signal.add(function(){
                });
                expect(signal.size()).toBeStrictlyEqualTo(3);
            });
        });

        describe("when dispatching", function(){
            it("should have 1 listener and be called after dispatching", function(){
                var called = false;
                var signal = new funk.signals.Signal();
                signal.add(function(){
                    called = true;
                });
                signal.dispatch();
                expect(called).toBeTruthy();
            });

            it("should have 2 listeners and be called after dispatching", function(){
                var called0 = false;
                var called1 = false;

                var signal = new funk.signals.Signal();
                signal.add(function(){
                    called0 = true;
                });
                signal.add(function(){
                    called1 = true;
                });
                signal.dispatch();
                expect(called0 && called1).toBeTruthy();
            });

            it("should have 1 listener and not be called if disabled", function(){
                var signal = new funk.signals.Signal();
                signal.add(function(){
                    fail();
                }).setEnabled(false);
                signal.dispatch();
            });

            it("should have 2 listeners and first 1 is disabled", function(){
                var called = false;

                var signal = new funk.signals.Signal();
                signal.add(function(){
                    fail();
                }).setEnabled(false);
                signal.add(function(){
                    called = true;
                });

                signal.dispatch();

                expect(called).toBeTruthy();
            });

            it("should have 2 listeners and second 1 is disabled", function(){
                var called = false;

                var signal = new funk.signals.Signal();
                signal.add(function(){
                    called = true;
                });
                signal.add(function(){
                    fail();
                }).setEnabled(false);

                signal.dispatch();

                expect(called).toBeTruthy();
            });

            it("should have 4 listeners and third 1 is disabled", function(){
                var called0 = false;
                var called1 = false;
                var called2 = false;
                var called3 = false;

                var signal = new funk.signals.Signal();
                signal.add(function(){
                    called0 = true;
                });
                signal.add(function(){
                    called1 = true;
                });
                signal.add(function(){
                    fail();
                }).setEnabled(false);
                signal.add(function(){
                    called2 = true;
                });
                signal.add(function(){
                    called3 = true;
                });

                signal.dispatch();

                expect(called0 && called1 && called2 && called3).toBeTruthy();
            });

            it("should pass \"Test\" through arguments", function(){
                var value = "Test";

                var signal = new funk.signals.Signal(String);
                signal.add(function(arg){
                    expect(arg).toBeStrictlyEqualTo(value);
                });
                signal.dispatch(value);
            });

            it("should pass {} through arguments and be same instance", function(){
                var value = {};

                var signal = new funk.signals.Signal(String);
                signal.add(function(arg){
                    expect(arg).toBeStrictlyEqualTo(value);
                });
                signal.dispatch(value);
            });

            it("should pass null through arguments", function(){
                var value = null;

                var signal = new funk.signals.Signal(null);
                signal.add(function(arg){
                    expect(arg).toBeStrictlyEqualTo(value);
                });
                signal.dispatch(value);
            });

            it("should pass null through arguments", function(){
                var value = undefined;

                var signal = new funk.signals.Signal(undefined);
                signal.add(function(arg){
                    expect(arg).toBeStrictlyEqualTo(value);
                });
                signal.dispatch(value);
            });
        });
    });
});