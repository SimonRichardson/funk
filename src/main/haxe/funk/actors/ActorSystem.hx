package funk.actors;

//import funk.actors.ActorRef;
//import funk.actors.ActorRefProvider;
//import funk.actors.Scheduler;
//import funk.actors.dispatch.Dispatcher;
//import funk.actors.dispatch.Dispatchers;
//import funk.actors.dispatch.Mailbox;
//import funk.actors.dispatch.MessageDispatcher;
import funk.actors.event.EventStream;

using funk.futures.Promise;
using funk.collections.immutable.List;
using funk.types.Any;


class ActorSystem {

    /*
    private var _provider : ActorRefProvider;

    private var _scheduler : Scheduler;

    private var _eventStream : EventStream;

    private var _deadLetterMailbox : Mailbox;

    private var _dispatchers : Dispatchers;

    private var _dispatcher : MessageDispatcher;
    */

    private var _name : String;

    private var _isTerminated : Bool;

    public function new(name : String/*, provider : ActorRefProvider*/) {
        _name = name;
        //_provider = provider;

        _isTerminated = false;

        //var deadLetters = _provider.deadLetters();
        //var deadLetterQueue = new DeadLetterQueue(deadLetters);
        //_deadLetterMailbox = new Mailbox(deadLetters.cell(), deadLetterQueue);

        //_scheduler = provider.scheduler();
        //_eventStream = provider.eventStream();

        //_dispatchers = new Dispatchers(_eventStream, _deadLetterMailbox, _scheduler);
    }

    public static function create(name : String/*, ?provider : ActorRefProvider = null*/) : ActorSystem {
        /*var dispatchers : Dispatchers = null;
        var refProvider = if(AnyTypes.toBool(provider)) provider;
        else {
            var scheduler = new DefaultScheduler(function() : MessageDispatcher {
                return dispatchers.defaultGlobalDispatcher();
            });
            new LocalActorRefProvider(name, new EventStream(), scheduler);
        }
        */
        var system = new ActorSystem(name);//, null);//refProvider);

        //dispatchers = system._dispatchers;

        return system;
    }

    /*
    public function child(name : String) : ActorPath return guardian().path().child(name);

    public function actorOf(props : Props, name : String) : Promise<EnumValue> {
        return guardian().ask(CreateChild(props, name), guardian());
    }

    public function start() : Void {
        _provider.init(this);
        _provider.terminationFuture().when(function(attempt) {
            stopScheduler();
        });
    }

    public function stop(actor : ActorRef) : Void {
        var path = actor.path();
        var guard = guardian().path();
        var sys = systemGuardian().path();

        switch(path.parent().name()) {
            case 'guard': guardian().ask(StopChild(actor), guardian());
            case 'sys': systemGuardian().ask(StopChild(actor), systemGuardian());
            case _ if(Std.is(actor, LocalActorRef)):
                var ref : LocalActorRef = cast actor;
                ref.stop();
        }
    }

    public function isTerminated() : Bool return _isTerminated;

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
    */
}
