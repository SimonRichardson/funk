package funk.actors;

import funk.actors.dispatch.Dispatcher;
import funk.actors.dispatch.SystemMessage;
import funk.Funk;
import funk.actors.dispatch.Mailbox;
import funk.actors.Actor;
import funk.actors.ActorContext;
import funk.actors.ActorCellChildren;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;
import funk.actors.events.LoggingBus;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;
import funk.types.Function0;
import funk.types.Predicate1;
import funk.types.extensions.EnumValues;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;
import haxe.ds.StringMap;
import haxe.Serializer;
import haxe.Unserializer;

using funk.actors.dispatch.EnvelopeMessage;
using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

interface Cell extends ActorContext {

    function init(uid : String, ?sendSupervise : Bool = true) : Void;

    function start() : ActorContext;

    function stop() : ActorContext;

    function suspend() : Void;

    function resume(causedByFailure : Dynamic) : Void;

    function restart(cause : Dynamic) : Void;

    function sendMessage(msg : EnvelopeMessage) : Void;

    function sendSystemMessage(msg : SystemMessage) : Void;

    function parent() : InternalActorRef;

    function child(name : String) : Option<ActorRef>;

    function getChildByName(name : String) : Option<ChildStats>;

    function become(value : Predicate1<AnyRef>, ?discardLast : Bool = false) : Void;

    function unbecome() : Void;
}

class ActorCell implements Cell implements ActorContext {

    private static var terminatedActorProps = new TerminatatedActorProps();

    private var _uid : String;

    private var _actor : Actor;

    private var _self : InternalActorRef;

    private var _system : ActorSystem;

    private var _props : Props;

    private var _parent : InternalActorRef;

    private var _children : Children;

    private var _dispatcher : Dispatcher;

    private var _currentMessage : EnvelopeMessage;

    private var _mailbox : Mailbox;

    private var _watching : List<ActorRef>;

    private var _watchedBy : List<ActorRef>;

    private var _becomingStack : List<Predicate1<AnyRef>>;

    private var _failed : ActorRef;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        _system = system;
        _self = self;
        _props = props;
        _parent = parent;

        _watching = Nil;
        _becomingStack = Nil.prepend(actorRecieve());

        _children = new Children(this);

        var dispatchers = _system.dispatchers();
        _dispatcher = dispatchers.find(_props.dispatcher());

        _mailbox = _dispatcher.createMailbox(this);
    }

    public function init(uid : String, ?sendSupervise : Bool = true) : Void {
        _mailbox.systemEnqueue(_self, Create(uid));

        if (sendSupervise) {
            _parent.sendSystemMessage(Supervise(_self, false, uid));
            // TODO (Simon) : Because we don't have async executions we can't send this.
            //_parent.send(NullMessage);
        }
    }

    public function start() : ActorContext {
        try _dispatcher.attach(this) catch (e : Dynamic) handleException(e);
        return this;
    }

    public function stop() : ActorContext {
        try _dispatcher.systemDispatch(this, Terminate) catch (e : Dynamic) handleException(e);
        return this;
    }

    public function suspend() : Void {
        try _dispatcher.systemDispatch(this, Suspend) catch (e : Dynamic) handleException(e);
    }

    public function resume(causedByFailure : Dynamic) : Void {
        try _dispatcher.systemDispatch(this, Resume(causedByFailure)) catch (e : Dynamic) handleException(e);
    }

    public function restart(cause : Dynamic) : Void {
        try _dispatcher.systemDispatch(this, Recreate(cause)) catch (e : Dynamic) handleException(e);
    }

    public function actorOf(props : Props, name : String) : ActorRef return _children.actorOf(props, name);

    public function actorFor(path : ActorPath) : Option<ActorRef> return _system.provider().actorFor(path);

    public function self() : InternalActorRef return _self;

    public function mailbox() : Mailbox return _mailbox;

    public function children() : List<ActorRef> return _children.children();

    public function system() : ActorSystem return _system;

    public function parent() : InternalActorRef return _parent;

    public function child(name : String) : Option<ActorRef> return _children.child(name);

    public function getChildByName(name : String) : Option<ChildStats> return _children.getChildByName(name);

    public function isTerminating() : Bool return _children.isTerminating();

    public function isTerminated() : Bool return _mailbox.isClosed();

    public function hasMessages() : Bool return _mailbox.hasMessages();

    public function numberOfMessages() : Int return _mailbox.numberOfMessages();

    public function sender() : Option<ActorRef> {
        return switch (_currentMessage) {
            case _ if(_currentMessage == null): Some(_system.deadLetters());
            case _ if(AnyTypes.toBool(_currentMessage.sender())): Some(_currentMessage.sender());
            case _: Some(_system.deadLetters());
        }
    }

    public function watch(actor : ActorRef) : Void {
        var a = AnyTypes.asInstanceOf(actor, InternalActorRef);
        if(a != self() && !_watching.exists(function(child) return child == a)) {
            a.sendSystemMessage(Watch(a, self()));
            _watching = _watching.prepend(a);
        }
    }

    public function unwatch(actor : ActorRef) : Void {
        var a = AnyTypes.asInstanceOf(actor, InternalActorRef);
        if(a != self() && _watching.exists(function(child) return child == a)) {
            a.sendSystemMessage(Unwatch(a, self()));
            _watching = _watching.filterNot(function(child) return child == a);
        }
    }

    public function sendMessage(envelope : EnvelopeMessage) : Void {
        try {
            // Note (Simon) : This be expensive, but good for thread safety (Share nothing)
            var msg = envelope.message();
            var message = if (_system.settings().serializeAllMessages()) Unserializer.run(Serializer.run(msg)) else msg;

            var sender = envelope.sender();
            var ref = AnyTypes.toBool(sender) ? sender : null;

            _dispatcher.dispatch(this, Envelope(message, ref));
        } catch(e : Dynamic) {
            handleException(e);
            throw e;
        }
    }

    public function sendSystemMessage(message : SystemMessage) : Void {
        try _dispatcher.systemDispatch(this, message) catch(e : Dynamic) {
            handleException(e);
            throw e;
        }
    }

    public function systemInvoke(message : SystemMessage) : Void {
        try {
            switch(message) {
                case Create(uid): systemCreate(uid);
                case Supervise(cell, async, uid): systemSupervise(cell, async, uid);
                case ChildTerminated(child): handleChildTerminated(child);
                case Terminate: systemTerminate();
                case Recreate(cause): systemRecreate(cause);
                case Suspend: systemSuspend();
                case Resume(inResponseToFailure): systemResume(inResponseToFailure);
                case Watch(watchee, watcher): addWatcher(watchee, watcher);
                case Unwatch(watchee, watcher): remWatcher(watchee, watcher);
                case _: // got to catch'em all.
            }
        } catch (e: Dynamic) {
            handleInvokeFailure(Nil, e);
        }
    }

    public function invoke(message : EnvelopeMessage) : Void {
        _currentMessage = message;

        var msg : AnyRef = message.message();
        try {
            switch(msg) {
                case _ if(AnyTypes.isEnum(msg) && EnumValues.getEnum(msg) == ActorMessages): autoReceiveMessage(message);
                case _: receiveMessage(msg);
            }
        } catch (e : Dynamic) {
            _currentMessage = null;
            handleInvokeFailure(Nil, e);
        }
        
        _currentMessage = null;
    }

    public function become(value : Predicate1<AnyRef>, ?discardLast : Bool = false) : Void {
        // Note: discard last can actually be very dangerous, by removing the last actor receive.
        if(discardLast) _becomingStack = _becomingStack.tail();
        _becomingStack = _becomingStack.prepend(value);
    }

    public function unbecome() : Void {
        _becomingStack = _becomingStack.tail();
    }

    public function initChild(ref : ActorRef) : Option<ChildStats> return _children.initChild(ref);

    public function attachChild(props : Props, name : String) : ActorRef return _children.attachChild(props, name);

    private function actorRecieve() : Predicate1<AnyRef> {
        return function(value : AnyRef) : Bool {
            _actor.receive(value);
            return false;
        };
    }

    private function autoReceiveMessage(message : EnvelopeMessage) : Void {
        // TODO (Simon) : Work on auto received messages.
        switch(cast message.message()) {
            case Failed(cause, uid): handleFailure(sender().getOrElse(function() return null), cause, uid);
            case Terminated(t) : watchedActorTerminated(t);
            case Kill: Funk.error(ActorKillError("Kill"));
            case PoisonPill: _self.stop();
            case SelectParent(m): _parent.send(m, message.sender());
            case _:
        }
    }

    private function receiveMessage(message : AnyRef) : Void {
        var p = _becomingStack;
        if (p.isEmpty()) _actor.receive(message);
        else {
            while(p.nonEmpty()) {
                var func = p.head();
                if (!func(message)) {
                    break;
                }

                p = p.tail();

                // Make sure we call the actor receive at the very end if required.
                if (p.isEmpty()) {
                    _actor.receive(message);
                }
            }
        }
    }

    private function newActor() : Actor {
        ActorContextInjector.pushContext(this);

        function finally() {
            ActorContextInjector.popContext();
        }

        var instance = null;
        try {
            var creator = _props.creator();
            instance = creator();
            if (!AnyTypes.toBool(instance)) {
                Funk.error(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            finally();
            publish(Error, ErrorMessage(e, self().path().toString(), null, 'unable to create new actor'));
            throw e;
        }

        finally();

        return instance;
    }

    private function systemCreate(uid : String) : Void {
        _uid = uid;

        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            if (AnyTypes.toBool(_actor)) {
                clearActorFields(_actor);
                _actor = null;
                _currentMessage = null;
            }
            publish(Error, ErrorMessage(e, self().path().toString(), null, 'unable to create system ${uid}'));
            throw e;
        }
    }

    private function systemSupervise(child : ActorRef, async : Bool, uid : String) : Void {
        if (!isTerminating()) {
            switch(_children.initChild(child)) {
                case Some(crs):
                    // Work out what to do here, is the uid required?
                    // crs.uid = uid;
                    handleSystemSupervise(crs, async);
                case _:
                    var msg = 'received Supervise from unregistered child "${child.path()}", this will not end well';
                    publish(Warn, WarnMessage(self().path().toString(), Type.getClass(_actor), msg));
                    Funk.error(ActorError(msg));
            }
        } else publish(Debug, DebugMessage( self().path().toString(),
                                            Type.getClass(_actor),
                                            'unable to supervise when terminating'
                                            ));
    }

    private function handleSystemSupervise(child : ChildStats, async : Bool) : Void {
        // TODO (Simon) : Implement RepointableActorRef.
    }

    private function systemTerminate() : Void {
        unwatchWatchedActors(_actor);

        children().foreach(function(child) AnyTypes.asInstanceOf(child, InternalActorRef).stop());

        if(!setChildrenTerminationReason(Termination)) finishTerminate();
    }

    private function systemSuspend() : Void {
        switch(_children.waitingForChildren()) {
            case None: faultSuspend();
            case _: // TODO (Simon) : Implement waiting children.
        }
    }

    private function systemRecreate(cause : Dynamic) : Void {
        switch(_children.waitingForChildren()) {
            case None: faultRecreate(cause);
            case _: // TODO (Simon) : Implement waiting children.
        }
    }

    private function systemResume(inResponseToFailure : Dynamic) : Void {
        switch(_children.waitingForChildren()) {
            case None: faultResume(inResponseToFailure);
            case _: // TODO (Simon) : Implement waiting children.
        }
    }

    private function setChildrenTerminationReason(reason : SuspendReason) : Bool {
        return _children.setChildrenTerminationReason(reason);
    }

    private function clearActorFields(actor : Actor) : Void {
        _actor._context = null;
        _actor._self = null;
    }

    private function setActorFields(actor : Actor, context : ActorContext, self : ActorRef) : Void {
        if (AnyTypes.toBool(actor)) {
            _actor._context = context;
            _actor._self = self;
        }
    }

    private function clearActorCellFields(cell : ActorCell) : Void cell._props = terminatedActorProps;

    private function suspendChildren(exceptFor : List<ActorRef>) : Void _children.suspendChildren(exceptFor);

    private function resumeChildren(causedByFailure : Dynamic, perp : ActorRef) : Void {
        _children.resumeChildren(causedByFailure, perp);
    }

    private function handleFailure(child : ActorRef, cause : Dynamic, uid : String) {
        switch(_children.getChildByRef(child)) {
            case Some(stats) if (ChildStatsTypes.uid(stats) == uid): 
                if (!_actor.supervisorStrategy().handleFailure(this, child, cause, stats, _children.getAllChildStats())) {
                    throw cause;
                }
            case Some(stats): 
                publish(Debug, DebugMessage(    _self.path().toString(), 
                                                Type.getClass(_actor), 
                                                'dropping Failed($cause) from old child $child (uid=${ChildStatsTypes.uid(stats)} != $uid)'
                                                ));
            case None:
                publish(Debug, DebugMessage(    _self.path().toString(), 
                                                Type.getClass(_actor), 
                                                'dropping Failed($cause) from unknown child $child'
                                                ));
        }
    }

    private function handleChildTerminated(child : ActorRef) : Void {
        var status = _children.removeChildAndGetStateChange(child);

        if (AnyTypes.toBool(_actor)) {
            try _actor.supervisorStrategy().handleChildTerminated(this, child, _children.children()) catch(e : Dynamic) {
                publish(Error, ErrorMessage(e, _self.path().toString(), Type.getClass(_actor), 'handleChildTerminated failed'));
                handleInvokeFailure(Nil, e);
            }
        }

        // TODO (Simon) : Work out if we need to handle termination correctly c.dequeueAll etc.
        switch(status) {
            case Some(Recreation(cause)): finishRecreate(cause, _actor); 
            case Some(Creation): finishCreate(); 
            case Some(Termination): finishTerminate(); 
            case _:
        }
    }

    private function unwatchWatchedActors(actor : Actor) : Void {
        if(!_watching.isEmpty()) {
            _watching.foreach(function(a) {
                if(AnyTypes.isInstanceOf(a, InternalActorRef)) {
                    var watchee : InternalActorRef = cast a;
                    watchee.sendSystemMessage(Unwatch(watchee, self()));
                }
            });

            _watching = Nil;
        }
    }

    private function watchedActorTerminated(actor : ActorRef) {
        // TODO (Simon) : Work this out.
        /*if (_watching.contains(actor)) {
            // TODO (Simon) : maintain address of terminated actors.
            unwatchWatchedActors(actor);
            receiveMessage(Terminated(actor));
        }*/
    }

    private function addWatcher(watchee : ActorRef, watcher : ActorRef) : Void {
        var watcheeSelf = watchee == _self;
        var watcherSelf = watcher == _self;

        if (watcheeSelf && !watcherSelf) {
            if (!_watchedBy.contains(watcher)) {
                _watchedBy = _watchedBy.prepend(watcher);
                publish(Debug, DebugMessage(_self.path().toString(), Type.getClass(_actor), 'now monitoring $watcher'));
            }
        } else if(!watcheeSelf && watcherSelf) {
            watch(watchee);
        } else {
            publish(Warn, WarnMessage(  _self.path().toString(), 
                                        Type.getClass(_actor), 
                                        'BUG: illegal Watch($watchee, $watcher) for $_self'
                                        ));
        }
    }

    private function remWatcher(watchee : ActorRef, watcher : ActorRef) : Void {
        var watcheeSelf = watchee == _self;
        var watcherSelf = watcher == _self;

        if (watcheeSelf && !watcherSelf) {
            if (_watchedBy.contains(watcher)) {
                _watchedBy = _watchedBy.filterNot(function(w) return w == watcher);
                publish(Debug, DebugMessage(_self.path().toString(), Type.getClass(_actor), 'stopped monitoring $watcher'));
            }
        } else if(!watcheeSelf && watcherSelf) {
            unwatch(watchee);
        } else {
            publish(Warn, WarnMessage(  _self.path().toString(), 
                                        Type.getClass(_actor), 
                                        'BUG: illegal Unwatch($watchee, $watcher) for $_self'
                                        ));
        }
    }

    private function faultSuspend() : Void {
        suspendNonRecursive();
        suspendChildren(Nil);
    }

    private function faultRecreate(cause : Dynamic) : Void {
        if (!AnyTypes.toBool(_actor)) {
            publish(Error, ErrorMessage(    cause, 
                                            _self.path().toString(), 
                                            Type.getClass(_actor),
                                            'changing Recreate into Create after $cause'
                                            ));
            faultCreate();
        } else if(isNormal()) { 
            var failedActor = _actor;

            publish(Debug, DebugMessage(_self.path().toString(), Type.getClass(_actor), 'restarting')); 

            if (AnyTypes.toBool(failedActor)) {
                var optionalMessage = AnyTypes.toBool(_currentMessage) ? Some(_currentMessage.message()) : None;
                try {
                    if (AnyTypes.toBool(failedActor.context())) failedActor.preRestart(cause, optionalMessage);
                } catch (e : Dynamic) {
                    publish(Error, ErrorMessage(e, _self.path().toString(), Type.getClass(_actor), Std.string(e)));
                }

                if (!_mailbox.isSuspended()) {
                    Funk.error(ActorError('mailbox must be suspended during restart, status=${_mailbox.status()}'));
                }

                if (!setChildrenTerminationReason(Recreation(cause))) finishRecreate(cause, failedActor);
            }
        } else {
            faultResume(null);
        }
    }

    private function faultResume(causedByFailure : Dynamic) : Void {
        var e = causedByFailure;
        if (!AnyTypes.toBool(_actor)) {
            publish(Error, ErrorMessage(e, _self.path().toString(), null, 'changing Resume into Create after $e'));
            faultCreate();
        } else if (!AnyTypes.toBool(_actor.context()) && !AnyTypes.toBool(causedByFailure)) {
            publish(Error, ErrorMessage(    e, 
                                            _self.path().toString(), 
                                            Type.getClass(_actor),
                                            'changing Resume into Restart after $e'
                                            ));
            faultRecreate(causedByFailure);
        } else {
            var perp = perpetrator();
            try resumeNonRecursive() catch(e : Dynamic) {}
            if (causedByFailure != null) clearFailed();
            resumeChildren(causedByFailure, perp);
        }
    }

    private function faultCreate() : Void {
        if (!_mailbox.isSuspended()) {
            Funk.error(ActorError('mailbox must be suspended during creation, status=${_mailbox.status()}'));
        }

        _children.children().foreach(function(child) child.context().stop());

        if (!setChildrenTerminationReason(Creation)) finishCreate();
    }

    private function finishCreate() : Void {
        try resumeNonRecursive() catch (error : Dynamic) {}
        clearFailed();
        systemCreate(_uid);
    }

    private function finishRecreate(cause : Dynamic, failedActor : Actor) : Void {
        var survivors = _children.children();

        try {
            try resumeNonRecursive() catch (error : Dynamic) {}
            clearFailed();

            var freshActor = newActor();
            _actor = freshActor;
            if (freshActor == failedActor) setActorFields(freshActor, this, self());

            freshActor.postRestart(cause);

            survivors.foreach(function(child) {
                try AnyTypes.asInstanceOf(child, InternalActorRef).restart(cause) catch(e : Dynamic) {
                    publish(Error, ErrorMessage(    e, 
                                                    _self.path().toString(), 
                                                    Type.getClass(_actor),
                                                    'restarting $child'
                                                    ));
                }
            });
        } catch(e : Dynamic) {
            clearActorFields(_actor);
            handleInvokeFailure(survivors, new PostRestartException(_self, e, cause));
        }
    }

    private function handleInvokeFailure(childrenNotToSuspend : List<ActorRef>, error : Dynamic) : Void {
        try {
            if (!isFailed()) {
                suspendNonRecursive();

                function fail() {
                    setFailed(_self); 
                    return Nil;
                }

                var skip = if (AnyTypes.toBool(_currentMessage)) {
                    switch(_currentMessage) {
                        case Envelope(msg, child) if (AnyTypes.isValueOf(msg, ActorMessages)):
                            var message : ActorMessages = cast msg;
                            switch(message) {
                                case Failed(_, _): 
                                    setFailed(child); 
                                    Nil.prepend(child);
                                case _: fail();
                            }
                        case _: fail();
                    }
                } else fail();
                
                suspendChildren(skip.prependAll(childrenNotToSuspend));

                _parent.send(Failed(error, _uid), _self);
            }
        } catch (e : Dynamic) {
            publish(Error, ErrorMessage(    e, 
                                            _self.path().toString(), 
                                            Type.getClass(_actor),
                                            "emergency stop: exception in failure handling"
                                            ));

            // Try and stop all the children in an emergency situation.
            try _children.children().foreach(function(child) child.context().stop()) catch (e : Dynamic) {}
            finishTerminate();
        }
    }

    private function isNormal() : Bool return _children.isNormal();

    private function isFailed() : Bool return AnyTypes.toBool(_failed);

    private function setFailed(perpetrator : ActorRef) : Void _failed = perpetrator;

    private function clearFailed() : Void _failed = null;

    private function perpetrator() : ActorRef return _failed;

    private function handleException(e : Dynamic) : Void {
        // TODO (Simon) : Handle other errors.
        switch(e){
            case _: publish(Error, ErrorMessage(    e, 
                                                    _self.path().toString(), 
                                                    Type.getClass(_actor),
                                                    "exception during system message send"
                                                    ));
        }
    }

    private function suspendNonRecursive() : Void _dispatcher.suspend(this);

    private function resumeNonRecursive() : Void _dispatcher.resume(this);

    private function finishTerminate() : Void {
        try {
            if (AnyTypes.toBool(_actor) && AnyTypes.toBool(_actor.context())) {
                _actor.context().stop();
            }
        } catch (e : Dynamic) {
            publish(Error, ErrorMessage(e, _self.path().toString(), Type.getClass(_actor), Std.string(e)));
        }

        try _dispatcher.detach(this) catch(e : Dynamic) {}
        try _parent.sendSystemMessage(ChildTerminated(_self)) catch(e : Dynamic) {}       
        try unwatchWatchedActors(_actor) catch(e : Dynamic) {}

        try {
            publish(Debug, DebugMessage(_self.path().toString(), Type.getClass(_actor), 'stopped'));

            clearActorFields(_actor);
            clearActorCellFields(this);
        } catch(e : Dynamic) {}

        _actor = null;
    }

    private function publish(level : LogLevel, event : LogMessages) : Void {
        system().eventStream().publish(Data(level, event));
    }

    @:allow(funk.actors)
    private function actor() : Actor return _actor;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _system.provider();

    @:allow(funk.actors)
    private function dispatcher() : Dispatcher return _dispatcher;

    @:allow(funk.actors)
    private function reserveChild(name : String) : Void _children.reserveChild(name);

    @:allow(funk.actors)
    private function unreserveChild(name : String) : Void _children.unreserveChild(name);

    @:allow(funk.actors)
    private function currentMessage() : EnvelopeMessage return _currentMessage;

    @:allow(funk.actors)
    private function childrenRefs() : ChildrenContainer return _children.container();

    public function toString() return '[ActorCell (path=${self().path()})]';
}

@:final
private class PostRestartException {

    private var _self : InternalActorRef;

    private var _error : Dynamic;

    private var _cause : Dynamic;

    public function new(self : InternalActorRef, error : Dynamic, cause : Dynamic) {
        _self = self;
        _error = error;
        _cause = cause;
    }
}

@:final
private class TerminatatedActorProps extends Props {

    public function new() {
        super(null);
    }

    override public function creator() : Function0<Actor> {
        return Funk.error(IllegalOperationError("This Actor has been terminated"));
    }
}
