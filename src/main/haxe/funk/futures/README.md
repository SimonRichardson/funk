# Futures

Futures are objects that acts as a proxy for a result that is initially unknown, usually because the computation of 
its value is yet incomplete. If the value of a future is accessed asynchronously, for example by sending a message 
to it, or by explicitly waiting for it using a construct such as ```when```, then there is no difficulty in delaying 
until the future is resolved before the message can be received.

## Deferred

A promise object state is shielded from the outside in order to benefit from encapsulation and to prevent unwanted 
influence from external changes. The split into inner (deferred) and outer (promise) enables transparency for desired
operations, where state can only be changed in a deferred. The most important aspect is that it is not possible to
look inside of a deferred status from the outside, unless the promise publishes this information.

## State

A deferred object can only be resolved once, so in any given life time of the deferred it will either be in progress or
completed (either successfully or unsuccessfully). The deferred object will always remember the resolved value 
throughout the life time of the it and subsequent calls to get the value will return the result. Calling resolve or 
reject after an deferred object has been resolved will cause a error.

## Promise

A promise's purpose is the processing of listeners, and these listeners are enqueued to the promise object. The purpose
of a promise is to notify the listeners of changes found with in the deferred state. Each promise object supervises the
queued listeners, by sending them a progress, then, but and when state. A promise object is unable to change the state 
of a deferred in any possible way, as they're considered listeners of state.

# Example

## Resolve

Simple example showing the resolving of a deferred.

```
var deferred = new Deferred();
deferred.promise().then(function(v){
    trace(v); // outputs: 1
});
deferred.resolve(1);
```