package funk.actors;

using funk.actors.dispatch.Dispatcher;
using funk.actors.dispatch.Dispatchers;
using funk.actors.dispatch.Mailbox;
using funk.actors.dispatch.MessageDispatcher;
using funk.actors.event.EventStream;
using funk.futures.Promise;

class ActorSystem {

    private var _provider : ActorRefProvider;

    private var _scheduler : Scheduler;

    private var _dispatchers : Dispatchers;

    private var _dispatcher : MessageDispatcher;

    private var _eventStream : EventStream;

    private var _name : String;

    function new(name : String, provider : ActorRefProvider) {
        _name = name;
        _provider = provider;

        _actors = Nil;

        _eventStream = new EventStream();

        var deadLetterQueue = new MessageQueue(deadLetters());
        _deadLetterMailbox = new Mailbox(deadLetters(), deadLetterQueue);

        _scheduler = new DefaultScheduler(function() {
            return _dispatchers.defaultGlobalDispatcher;
        });
        _dispatchers = new Dispatchers(_eventStream, _deadLetterMailbox, _scheduler);
    }

    public static function create(name : String) : Void {
        return new ActorSystem(name, new ActorRefProvider());
    }

    public function child(name : String) : ActorPath return guardian.path().child(name);

    public function actorOf(props : Props, name : String) : Promise<ActorRef> {
        return guardian().ask(CreateChild(props, name));
    }

    public function start() : Void {
        _provider.init(this);
        _provider.terminationFuture().when(function() {
            stopScheduler();
        });
    }

    public function stop() : Void guardian().stop();

    public function shutdown() : Void guardian().stop();

    public function deadLetters() : ActorRef return _provider.deadLetters();

    public function deadLetterMailbox() : Mailbox return _deadLetterMailbox;

    public function scheduler() : Scheduler return _scheduler;

    public function dispatcher() : MessageDispatcher return _dispatchers.defaultGlobalDispatcher;

    public function eventStream() : EventStream return _eventStream;

    public function name() : String return _name;

    inline private function guardian() : InternalActorRef return _provider.guardian();

    inline private function systemGuardian() : InternalActorRef return _provider.systemGuardian();

    private function stopScheduler() : Void _scheduler.close();
}

class InternalActorRef extends ActorRef {

    public function new() {
        super();
    }
}
