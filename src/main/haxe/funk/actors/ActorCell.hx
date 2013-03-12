package funk.actors;

class ActorCell {

    private var _actor : Actor;

    private var _mailbox : Mailbox;

    private var _dispatcher : MessageDispatcher;

    private var _system : ActorSystem;

    private var _childrenRefs : List<ActorRef>;

    public function new() {
        _dispatcher = _system.dispatchers.find(function(value) {
            return value == props.dispatcher();
        }).get();
    }

    public function start() {
        _mailbox = _dispatcher.createMailbox(this);
        _mallbox.systemEnqueue(self(), Create);

        _parent.sendSystemMessage(Supervise(self()));

        _dispatcher.attach(this);
    }

    public function suspend() : Void _dispatcher.systemDispatch(this, Suspend);

    public function resume() : Void _dispatcher.systemDispatch(this, Resume);
    
    public function stop() : Void _dispatcher.systemDispatch(this, Stop);

    public function children() : List<ActorRef> return _childrenRefs.children;

    public function tell<T>(message : T, sender : ActorRef) : Void {
        var ref = AnyTypes.toBool(sender)? sender : _system.deadLetters;
        _dispatcher.dispatch(this, Envelope(message, ref)(system));
    }

    public function newActor() : Actor {
        try {
            var instance = props.creator();

            if (AnyTypes.toBool(instance)) {
                Funk.Errors(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            throw e;
        }
    }

    public function systemInvoke(message : SystemMessage) {
        switch(message) {
            case Create: create();
            case Recreate(cause): recreate(cause);
            case Link(subject): link(subject);
            case Unlink(subject): unlink(subject);
            case Suspend: suspend();
            case Resume: resume();
            case Terminated: terminated();
            case Supervise(child): supervise(child);
            case ChildTerminated(child): handChildTerminated(child);
        }
    }

    private function create() : Void {
        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            _parent.tell(Failed(self, "exception during creation"));
        }
    }

    private function recreate(cause : Errors) : Void {
        switch(cause) {
            
        }
    }
}