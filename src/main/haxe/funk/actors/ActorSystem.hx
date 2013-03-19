package funk.actors;

using funk.actors.ActorRef;
using funk.actors.ActorRefProvider;
using funk.actors.Scheduler;
using funk.actors.dispatch.Dispatcher;
using funk.actors.dispatch.Dispatchers;
using funk.actors.dispatch.Mailbox;
using funk.actors.dispatch.MessageDispatcher;
using funk.actors.event.EventStream;
using funk.futures.Promise;
using funk.collections.immutable.List;
using funk.types.Any;
using funk.types.Lazy;

class ActorSystem {

    private var _provider : ActorRefProvider;

    private var _scheduler : Scheduler;

    private var _dispatchers : Dispatchers;

    private var _dispatcher : MessageDispatcher;

    private var _eventStream : EventStream;

    private var _deadLetterMailbox : Mailbox;

    private var _name : String;

    private var _isTerminated : Bool;

    function new(name : String, provider : ActorRefProvider) {
        _name = name;
        _provider = provider;

        _isTerminated = false;

        var deadLetters = _provider.deadLetters();
        var deadLetterQueue = new DeadLetterQueue(deadLetters);
        _deadLetterMailbox = new Mailbox(deadLetters.cell(), deadLetterQueue);

        _scheduler = provider.scheduler();
        _eventStream = provider.eventStream();

        _dispatchers = new Dispatchers(_eventStream, _deadLetterMailbox, _scheduler);
    }

    public static function create(name : String, ?provider : ActorRefProvider = null) : ActorSystem {
        var refProvider = if(AnyTypes.toBool(provider)) provider;
        else {
            var dispatchers = null;
            var scheduler = new DefaultScheduler(function() {
                return dispatchers.defaultGlobalDispatcher;
            });
            var localProvider = new LocalActorRefProvider(name, new EventStream(), scheduler);

            dispatchers = localProvider._dispatchers;
            
            return provider;
        }
        
        return new ActorSystem(name, refProvider);
    }

    public function child(name : String) : ActorPath return guardian().path().child(name);

    public function actorOf(props : Props, name : String) : Promise<EnumValue> {
        return guardian().ask(CreateChild(props, name), guardian());
    }

    public function start() : Void {
        _provider.init(this);
        _provider.terminationFuture().when(function() {
            stopScheduler();
        });
    }

    public function stop(actor : ActorRef) : Void {
        var path = actor.path();
        var guard = guardian().path();
        var sys = systemGuardian().path();

        switch(path.parent()) {
            case 'guard': guardian().ask(StopChild(actor));
            case 'sys': systemGuardian().ask(StopChild(actor));
            case _ if(Std.is(actor, InternalActorRef)):
                var ref : InternalActorRef = cast actor;
                ref.stop();
        }
    }

    public function isTerminated() : Void return _isTerminated;

    public function shutdown() : Void guardian().stop();

    public function deadLetters() : ActorRef return _provider.deadLetters();

    public function deadLetterMailbox() : Mailbox return _deadLetterMailbox;

    public function scheduler() : Scheduler return _scheduler;

    public function dispatcher() : MessageDispatcher return _dispatchers.defaultGlobalDispatcher();

    public function dispatchers() : Dispatchers return _dispatchers;

    public function eventStream() : EventStream return _eventStream;

    public function name() : String return _name;

    public function provider() : ActorRefProvider return _provider;

    inline private function guardian() : InternalActorRef return _provider.guardian();

    inline private function systemGuardian() : InternalActorRef return _provider.systemGuardian();

    private function stopScheduler() : Void _scheduler.close();

    public function toString() : String _lookupRoot.path().root().address().toString();
}
