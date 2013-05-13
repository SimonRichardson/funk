package funk.actors.dispatch;

import funk.actors.ActorCell;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageQueue;
import funk.actors.dispatch.SystemMessage;
import funk.actors.events.EventStream;
import funk.actors.events.LoggingBus;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;

using funk.types.Option;
using funk.ds.immutable.List;

interface Dispatcher {

    function attach(actor : ActorCell) : Void;

    function detach(actor : ActorCell) : Void;

    function suspend(actor : ActorCell) : Void;

    function resume(actor : ActorCell) : Void;    

    function createMailbox(actor : ActorCell) : Mailbox;

    function dispatch(actor : ActorCell, envelope : EnvelopeMessage) : Void;

    function systemDispatch(receiver : ActorCell, invocation : SystemMessage) : Void;

    function registerForExecution(mailbox : Mailbox, hasMessageHint: Bool, hasSystemMessageHint: Bool) : Void;

    function name() : String;

    function throughput() : Int;

    function throughputDeadlineTime() : Int;

    function isThroughputDeadlineTimeDefined() : Bool;
}

interface DispatcherPrerequisites {

    function scheduler() : Scheduler;

    function eventStream() : EventStream;
}

class MessageDispatcher implements Dispatcher {

    private var _name : String;

    private var _actors : List<ActorRef>;

    private var _inhabitants : Int;

    private var _scheduler : Scheduler;

    private var _prerequisites : DispatcherPrerequisites;

    public function new(name : String, prerequisites : DispatcherPrerequisites) {
        _name = name;
        _prerequisites = prerequisites;

        // TODO (Simon) This needs to be changed to executioner.
        _scheduler = _prerequisites.scheduler();

        _actors = Nil;
        _inhabitants = 0;
    }

    public function createMailbox(actor : ActorCell) : Mailbox {
        return new Mailbox(actor, MailboxMessageQueue.create(actor.toOption()));
    }

    public function attach(actor : ActorCell) : Void {
        register(actor);
        registerForExecution(actor.mailbox(), false, true);
    }

    public function detach(actor : ActorCell) : Void {
        unregister(actor);
        ifSensibleToDoSoThenScheduleShutdown();
    }

    public function suspend(actor : ActorCell) : Void {
        var mbox = actor.mailbox();
        if ((mbox.actor() == actor) && mbox.dispatcher() == this) mbox.suspend();
    }

    public function resume(actor : ActorCell) : Void {
        var mbox = actor.mailbox();
        if ((mbox.actor() == actor) && (mbox.dispatcher() == this) && mbox.resume()) {
            registerForExecution(mbox, false, false);
        }
    }

    public function dispatch(receiver : ActorCell, invocation : EnvelopeMessage) : Void {
        var mbox = receiver.mailbox();
        mbox.enqueue(receiver.self(), invocation);
        registerForExecution(mbox, true, false);
    }

    public function systemDispatch(receiver : ActorCell, invocation : SystemMessage) : Void {
        var mbox = receiver.mailbox();
        mbox.systemEnqueue(receiver.self(), invocation);
        registerForExecution(mbox, false, true);
    }

    public function name() : String return _name;

    public function registerForExecution(mailbox : Mailbox, hasMessageHint: Bool, hasSystemMessageHint: Bool) : Void {
        if (mailbox.canBeScheduledForExecution(hasMessageHint, hasSystemMessageHint)) {
            if(mailbox.setAsScheduled()) {
                // Essentially this is saying wait for next frame of execution.
                // Note : Changing this value does change how the scheduler runs.
                try _scheduler.scheduleRunnerOnce(0, 10, mailbox) catch (e : Dynamic) {
                    mailbox.setAsIdle();
                }
            }
        }
    }

    public function throughput() : Int return 0;

    public function throughputDeadlineTime() : Int return 0;

    public function isThroughputDeadlineTimeDefined() : Bool return throughputDeadlineTime() > 0;

    private function register(actor : ActorCell) : Void {
        _actors = _actors.prepend(actor.self());
        addInhabitants(1);
    }

    private function unregister(actor : ActorCell) : Void {
        var self = actor.self();
        _actors = _actors.filterNot(function(a) return a == self);
        addInhabitants(-1);
    }

    private function addInhabitants(value : Int) : Void {
        var r = _inhabitants + value;
        if (r < 0) {
            Funk.error(ActorError("ACTOR SYSTEM CORRUPTED!!! A dispatcher can't have less than 0 inhabitants!"));
        }
        _inhabitants = r;
    }

    private function ifSensibleToDoSoThenScheduleShutdown() : Void {
        if (_inhabitants <= 0) {
            shutdown();
        }
    }

    private function shutdown() : Void {
        try _scheduler.close() catch(e : Dynamic) {
            _prerequisites.eventStream().publish(Data(Error, ErrorMessage(  e,
                                                                            '',
                                                                            null,
                                                                            "exception during shutdown"
                                                                            )));
            throw e;
        }
    }
}
