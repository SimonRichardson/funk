package funk.actors;

import funk.Funk;
import funk.actors.Actor;
import funk.actors.ActorCell;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageQueue;
import funk.types.AnyRef;

using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.List;

class StashActor extends Actor {

    private var _stash : List<EnvelopeMessage>;

    private var _capacity : Int;

    private var _queue : QueueBaseMessageQueue;

    public function new() {
        super();

        _stash = Nil;
        _capacity = -1; // Make configurable 

        var messageQueue = context().asInstanceOf(ActorCell).mailbox().messageQueue();
        if (AnyTypes.isInstanceOf(messageQueue, QueueBaseMessageQueue)) _queue = cast messageQueue;
        else Funk.error(ActorError('DequeBasedMailbox required, got: ${Type.getClass(messageQueue)}'));
    }

    public function stash() : Void {
        var currentMessage = context().asInstanceOf(ActorCell).currentMessage();
        if (_stash.size() > 0 && (_stash.head() == currentMessage)) {
            Funk.error(IllegalOperationError('Can\'t stash the same message $currentMessage more than once'));
        }

        if (_capacity <= 0 || _stash.size() < _capacity) _stash = _stash.prepend(currentMessage);
        else Funk.error(ActorError('Couldn\'t enqueue message $currentMessage to stash of ${context().self()}'));
    }

    public function unstashAll() : Void {
        function finally() {
            _stash = Nil;
        }

        try {
            var self = context().self();
            var iterator = _stash.reverse().iterator();
            while(iterator.hasNext()) _queue.enqueueFirst(self, iterator.next());
        } catch (error : Dynamic) {
            finally();
            throw error;
        }

        finally();
    }

    override public function postStop() : Void unstashAll();

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {
        try unstashAll() catch(error : Dynamic) {
            super.preRestart(reason, message); 
            throw error;
        }
        super.preRestart(reason, message);
    }
}
