package funk.actors;

class ActorSystem {

    private var _provider : ActorRefProvider;

    private var _scheduler : Scheduler;

    private var _dispatchers : Dispatchers;

    private var _dispatcher : MessageDispatcher;

    public function new() {
        _actors = Nil;
        
        _scheduler = new DefaultScheduler(function() {
            return _dispatchers.defaultGlobalDispatcher;
        });
        _dispatchers = new Dispatchers(_deadLetterMailbox, _scheduler);   
    }

    public function actorOf(props : Props, name : String) : Promise<ActorRef> {
        return guardian().ask(CreateChild(props, name));
    }

    public function start() : Void {
        _provider.init(this);
        _provider.terminationFuture().when(function() {
            stopScheduler();
        });
    }

    public function shutdown() : Void {
        guardian().stop();
    }

    public function deadLetters() : ActorRef {

    }

    public function scheduler() : Scheduler {
        
    }

    public function dispatcher() : MessageDispatcher {

    }

    inline private function guardian() : InternalActorRef {
        return _provider.guardian();
    }

    private function stopScheduler() : Void {
        _scheduler.close();
    }
}
