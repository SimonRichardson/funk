package funk.actors.dispatch;

import funk.actors.ActorCell;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageQueue;
import funk.actors.dispatch.SystemMessage;

using funk.types.Option;
using funk.collections.immutable.List;

interface Dispatcher {

    function attach(actor : ActorCell) : Void;

    function detach(actor : ActorCell) : Void;

    function createMailbox(actor : ActorCell) : Mailbox;

    function dispatch(actor : ActorCell, envelope : Envelope) : Void;

    function systemDispatch(receiver : ActorCell, invocation : SystemMessage) : Void;

    function registerForExecution(mailbox : Mailbox, hasMessageHint: Bool, hasSystemMessageHint: Bool) : Void;

    function name() : String;

    function throughput() : Int;

    function throughputDeadlineTime() : Int;

    function isThroughputDeadlineTimeDefined() : Bool;
}

class MessageDispatcher implements Dispatcher {

    private var _name : String;

    private var _actors : List<ActorRef>;

    private var _inhabitants : Int;

    public function new(name : String) {
        _name = name;
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

    public function dispatch(receiver : ActorCell, invocation : Envelope) : Void {
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
                try {
                    mailbox.run();
                } catch (e : Dynamic) {
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

    }
}
