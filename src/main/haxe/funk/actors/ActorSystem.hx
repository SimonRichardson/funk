package funk.actors;

class ActorSystem {

    private var _provider : ActorRefProvider;

    private var _scheduler : Scheduler;

    private var _dispatchers : Dispatchers;

    private var _dispatcher : MessageDispatcher;

    private var _eventBus : EventStream;

    public function new(provider : ActorRefProvider) {
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

    public function stop() : Void { guardian().stop(); }

    public function shutdown() : Void { guardian().stop(); }

    public function deadLetters() : ActorRef return _provider.deadLetters();

    public function deadLetterMailbox() : Mailbox return _deadLetterMailbox;

    public function scheduler() : Scheduler return _scheduler;

    public function dispatcher() : MessageDispatcher return _dispatchers.defaultGlobalDispatcher;

    inline private function guardian() : InternalActorRef return _provider.guardian();

    inline private function systemGuardian() : InternalActorRef return _provider.systemGuardian();

    private function stopScheduler() : Void { _scheduler.close(); }
}
