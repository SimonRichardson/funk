package funk.actors;

import funk.Funk;

using funk.actors.dispatch.Envelope;
using funk.actors.dispatch.Mailbox;
using funk.actors.dispatch.MessageDispatcher;
using funk.actors.Actor;
using funk.actors.ActorSystem;
using funk.actors.ActorRef;
using funk.actors.ActorRefProvider;
using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.List;

typedef ActorContext = {> ActorRefFactory,

    function children() : List<ActorRef>;

    function parent() : ActorRef;

    function props() : Props;

    function self() : ActorRef;

    function sender() : ActorRef;

    function system() : ActorSystem;

    function watch(subject : ActorRef) : ActorRef;

    function unwatch(subject : ActorRef) : ActorRef;
};

class ActorContextInjector {

    private static var _contexts : List<ActorContext> = Nil;

    private static var _currentContext : Option<ActorContext> = None;

    public static function pushContext(context : ActorContext) : Void {
        _currentContext = Some(context);
        _contexts = _contexts.prepend(context);
    }

    public static function popContext() : Void {
        _contexts = _contexts.tail();
        _currentContext = _contexts.headOption();
    }

    inline public static function currentContext() : Option<ActorContext> return _currentContext;
}

class ActorCell {

    private var _actor : Actor;

    private var _self : InternalActorRef;

    private var _mailbox : Mailbox;

    private var _dispatcher : MessageDispatcher;

    private var _system : ActorSystem;

    private var _childrenRefs : List<InternalActorRef>;

    private var _currentMessage : EnvelopeMessage;

    private var _props : Props;

    private var _parent : InternalActorRef;

    private var _isTerminating : Bool;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        _system = system;
        _self = self;
        _props = props;
        _parent = parent;

        _isTerminating = false;

        _childrenRefs = Nil;

        _dispatcher = _system.dispatchers().lookup(_props.dispatcher());
    }

    public function start() {
        _mailbox = _dispatcher.createMailbox(this);
        _mailbox.systemEnqueue(self(), Nil.prepend(Create));

        _parent.sendSystemMessage(Supervise(_self));

        _dispatcher.attach(this);
    }

    public function suspend() : Void _dispatcher.systemDispatch(this, Suspend);

    public function resume() : Void _dispatcher.systemDispatch(this, Resume);

    public function restart(cause : Errors) : Void _dispatcher.systemDispatch(this, Recreate(cause));

    public function stop(?actor : ActorRef = null) : Void {
        if (AnyTypes.toBool(actor)) {
            var opt = _childrenRefs.find(function(a) return a.name() == actor.name());
            if (Std.is(actor, LocalActorRef)) {
                var local : LocalActorRef = cast actor;
                local.stop();
            }
        } else _dispatcher.systemDispatch(this, Terminated);
    }

    public function watch(subject : ActorRef) : ActorRef {
        _dispatcher.systemDispatch(this, Link(subject));
        return subject;
    }

    public function unwatch(subject : ActorRef) : ActorRef {
        _dispatcher.systemDispatch(this, Unlink(subject));
        return subject;
    }

    public function children() : List<ActorRef> return cast _childrenRefs;

    public function tell(message : EnumValue, sender : ActorRef) : Void {
        var ref = AnyTypes.toBool(sender)? sender : _system.deadLetters();
        _dispatcher.dispatch(this, Envelope(message, ref));
    }

    public function sender() : ActorRef {
        return switch(_currentMessage) {
            case Envelope(_, sender) if (AnyTypes.toBool(sender)): sender;
            case _: _system.deadLetters();
        }
    }

    public function name() : String return _self.name();

    public function props() : Props return _props;

    public function self() : ActorRef return _self;

    public function mailbox() : Mailbox return _mailbox;

    public function guardian() : InternalActorRef return _self;

    public function lookupRoot() : InternalActorRef return _self;

    public function system() : ActorSystem return _system;

    public function provider() : ActorRefProvider return _system.provider();

    public function dispatcher() : MessageDispatcher return _dispatcher;

    public function parent() : ActorRef return _parent;

    public function actorOf(props : Props, name : String) : ActorRef {
        var opt : Option<InternalActorRef> = _childrenRefs.find(function(actor) return actor.name() == name);
        return switch(opt) {
            case None:
                var actor : InternalActorRef;
                if (isTerminating()) {
                    // Fixme, we should get an actorFor
                    Funk.error(ActorError('Actor isTerminating'));
                } else {
                    actor = provider().actorOf(system(), props, self(), self().path().child(name));
                    _childrenRefs = _childrenRefs.prepend(actor);
                }
                cast actor;
            case _: Funk.error(ActorError('Actor name $name is not unique!'));
        }
    }

    public function newActor() : Actor {
        ActorContextInjector.pushContext(this);

        var instance = null;
        try {
            instance = props().creator()();

            if (AnyTypes.toBool(instance)) {
                Funk.error(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            throw e;
        }

        ActorContextInjector.popContext();

        return instance;
    }

    public function systemInvoke(message : SystemMessage) {
        switch(message) {
            case Create: systemCreate();
            case Recreate(cause): systemRecreate(cause);
            case Link(subject): systemLink(subject);
            case Unlink(subject): systemUnlink(subject);
            case Suspend: systemSuspend();
            case Resume: systemResume();
            case Terminated: systemTerminated();
            case Supervise(child): systemSupervise(child);
            case ChildTerminated(child): handChildTerminated(child);
            case _:
        }
    }

    public function invoke(message : EnvelopeMessage) {
        _currentMessage = message;
    }

    public function isTerminating() : Bool return _isTerminating;

    private function systemCreate() : Void {
        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            _parent.tell(Failed(ActorError("exception during creation")), self());
        }
    }

    private function systemRecreate(cause : Errors) : Void {
        switch(cause) {
            case _: // TODO (Simon) : Work out if we can reboot the actor.
        }
    }

    private function systemSuspend() : Void if(isNormal()) _dispatcher.suspend(this);

    private function systemResume() : Void if(isNormal()) _dispatcher.resume(this);

    private function systemLink(subject : ActorRef) : Void {
        if (!isTerminating()) {
            // TODO (Simon) : Workout if we need to link
        }
    }

    private function systemUnlink(subject : ActorRef) : Void {
        if (!isTerminating()) {
            // TODO (Simon) : Workout if we need to link
        }
    }

    private function systemTerminated() : Void {
        _childrenRefs.foreach(function(value) value.stop());

        _dispatcher.detach(this);
        _parent.sendSystemMessage(ChildTerminated(_self));
        _actor = null;
    }

    private function systemSupervise(child : InternalActorRef) : Void {
        var opt = _childrenRefs.find(function(value) return value == child);
        if (opt.isEmpty()) {
            _childrenRefs = _childrenRefs.prepend(child);
        }
    }

    private function handChildTerminated(child : ActorRef) : Void {
        _childrenRefs = _childrenRefs.filterNot(function(value) return value == child);
    }

    private function childrenRefs() : List<InternalActorRef> return _childrenRefs;

    private function isNormal() : Bool return true;
}
