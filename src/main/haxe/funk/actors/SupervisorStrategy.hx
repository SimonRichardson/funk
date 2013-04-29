package funk.actors;

import funk.actors.ActorRef;
import funk.actors.ActorCell;
import funk.actors.ActorCellChildren;
import funk.actors.ActorContext;
import funk.actors.events.LoggingBus;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;

using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.List;

enum Strategies {
    Resume;
    Restart;
    Stop;
    Escalate;
}

class SupervisorStrategy {

    public static var defaultDecider : Decider = new DefaultDecider();

    private var _decider : Decider;

    public function new(decider : Decider) {
        _decider = AnyTypes.toBool(decider) ? decider : defaultDecider;
    }

    public function handleChildTerminated(context : ActorContext, child : ActorRef, children : List<ActorRef>) : Void {}

    public function processFailure( context : ActorContext,
                                    restart : Bool,
                                    child : ActorRef,
                                    cause : Dynamic,
                                    stats : ChildStats,
                                    children : List<ChildStats>
                                    ) : Void {}

    public function handleFailure(  context : ActorContext,
                                    child : ActorRef,
                                    cause : Dynamic,
                                    stats : ChildStats,
                                    children: List<ChildStats>
                                    ) : Bool {
        var directive = _decider.decide(cause);

        logFailure(context, child, cause, directive);

        return switch(directive) {
            case Resume: resumeChild(child, cause); true;
            case Restart: processFailure(context, true, child, cause, stats, children); true;
            case Stop: processFailure(context, false, child, cause, stats, children); true;
            case _: false;
        }
    }

    public function resumeChild(child : ActorRef, cause : Dynamic) : Void {
        AnyTypes.asInstanceOf(child, InternalActorRef).resume(cause);
    }

    public function restartChild(child : ActorRef, cause : Dynamic, suspendFirst : Bool) : Void {
        var c = AnyTypes.asInstanceOf(child, InternalActorRef);
        if (suspendFirst) c.suspend();
        c.restart(cause);
    }

    private function logFailure(context : ActorContext, child : ActorRef, cause : Dynamic, directive : Strategies) : Void {
        var logMessage = cause;
        switch (directive) {
            case Resume: publish(context, Warn, WarnMessage(child.path().toString(), Type.getClass(this), logMessage));
            case Escalate: // don't log here
            case _: publish(context, Error, ErrorMessage(cause, child.path().toString(), Type.getClass(this), logMessage));
        }
    }

    private function publish(context : ActorContext, level : LogLevel, msg : LogMessages) : Void {
        try context.system().eventStream().publish(Data(level, msg)) catch (e : Dynamic) {
            // TODO (Simon) : Decide what to do here.
            throw e;
        }
    }
}

interface Decider {

    function decide(exception : Dynamic) : Strategies;
}

class OneForOneStrategy extends SupervisorStrategy {

    public function new(?decider : Decider = null) {
        super(decider);
    }

    override public function processFailure(    context : ActorContext,
                                                restart : Bool,
                                                child : ActorRef,
                                                cause : Dynamic,
                                                stats : ChildStats,
                                                children : List<ChildStats>
                                                ) : Void {
        if (restart) restartChild(child, cause, false);
        else context.stop();
    }
}

private class DefaultDecider implements Decider {

    public function new() {}

    public function decide(exception : Dynamic) : Strategies {
        return Restart;
    }
}
