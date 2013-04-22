# Actors

Actors are objects which encapsulate state and behavior, they communicate exclusively by exchanging messages 
which are placed into the recipients mailbox. In a sense, actors are the most stringent form of object-oriented 
programming.

## Actor Reference

An actor object is shielded from the outside in order to benefit from the actor model. Therefore, actors are 
represented to the outside using actor reference, which are objects that can be passed around freely and without 
restriction. This split into inner and outer object enables transparency for all the desired operations: 
restarting an actor without needing to update references elsewhere, sending messages to actors in completely different 
applications, but the most important aspect is that it is not possible to look inside an actor and get hold of its 
state from the outside, unless the actor unwisely publishes this information itself.

## State

Actor objects will typically contain some variables which reflect possible states the actor may be in. Because the 
internal state is vital to an actor’s operations, having inconsistent state is fatal. Thus, when the actor fails 
and is restarted by its supervisor, the state will be created from scratch, like upon first creating the actor. 
This is to enable the ability of self-healing of the system.

## Behaviour

Behavior means a function which defines the actions to be taken in reaction to the message at that point in time, 
say forward a request if the client is authorized, deny it otherwise. This behavior may change over time, 
e.g. because different clients obtain authorization over time, or because the actor may go into an "out-of-service" 
mode and later come back. These changes are achieved by either encoding them in state variables which are read 
from the behavior logic, or the function itself may be swapped out at runtime. However, the initial behavior 
defined during construction of the actor object is special in the sense that a restart of the actor will reset 
its behavior to this initial one.

## Mailbox

An actor’s purpose is the processing of messages, and these messages were sent to the actor from other actors. 
The piece which connects sender and receiver is the actor’s mailbox: each actor has exactly one mailbox to which 
all senders enqueue their messages. Enqueuing happens in the time-order of send operations, which means that 
messages sent from different actors may not have a defined order at runtime due to the apparent randomness of 
distributing actors across threads. Sending multiple messages to the same target from the same actor, 
on the other hand, will enqueue them in the same order.

An important feature in which differs from some other actor model implementations is that the current behavior must 
always handle the next dequeued message, there is no scanning the mailbox for the next matching one. Failure to 
handle a message will typically be treated as a failure, unless this behavior is overridden.

## Children

Each actor is potentially a supervisor: if it creates children for delegating sub-tasks, it will automatically 
supervise them. The list of children is maintained within the actor’s context and the actor has access to it. 
Modifications to the list are done by creating (```context.actorOf(...)```) or stopping (```context.stop(child)```) 
children and these actions are reflected immediately. The actual creation and termination actions happen behind the 
scenes in an asynchronous way, so they do not "block" their supervisor.

# Examples

## Ping Pong

Simple example of a ping pong actor system.

```
var system = ActorSystem.create('system');
var pong = system.actorOf(new Props(Pong), 'pong');
pong.ask("ping").when(function(attempt) {
    switch(attempt) {
        case Success(v): trace(v); // outputs: pong
        case _: 
    }
});

class Pong extends Actor {
    public function new() {
        super();
    }
    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(value == 'ping'): sender().send('pong');
            case _: 
        }
    }
}
```


<!--
    Original origin of documentation is from akka[1], because this is a port (not 1-1 port), there are very 
    similar things happening.

    [1] http://doc.akka.io/docs/akka/snapshot/general/actor-systems.html#actor-systems
-->