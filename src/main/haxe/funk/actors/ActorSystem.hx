package funk.actors;

import funk.actors.ActorCell;
import funk.actors.ActorCellChildren;
import funk.actors.ActorPath;
import funk.actors.ActorRefProvider;
import funk.actors.dispatch.Dispatchers;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageQueue;
import funk.actors.events.EventStream;
import funk.actors.Scheduler;

using funk.actors.ActorRef;
using funk.types.Option;
using funk.ds.immutable.List;
using funk.types.extensions.Strings;
using funk.types.Any;
using funk.futures.Promise;

class ActorSystem {

    private var _name : String;

    private var _isTerminated : Bool;

    private var _provider : ActorRefProvider;

    private var _dispatchers : Dispatchers;

    private var _scheduler : Scheduler;

    function new(name : String, refProvider : ActorRefProvider) {
        _name = name;

        _isTerminated = false;
        _provider = refProvider;

        _scheduler = new DefaultScheduler();
        _dispatchers = new Dispatchers(this);
    }

    public static function create(name : String, ?refProvider : ActorRefProvider) : ActorSystem {
        var provider = AnyTypes.toBool(refProvider) ? refProvider : new LocalActorRefProvider();
        var system = new ActorSystem(name, provider);
        return system.start();
    }

    public function actorOf(props : Props, name : String) : ActorRef {
        return _provider.guardian().context().actorOf(props, name);
    }

    public function actorFor(path : ActorPath) : Option<ActorRef> return _provider.guardian().context().actorFor(path);

    public function start() : ActorSystem {
        _provider.init(this);
        return this;
    }

    public function actorPath() : ActorPath return _provider.rootPath();

    public function child(name : String) : ActorPath return actorPath().child(name);

    public function name() : String return _name;

    public function deadLetters() : ActorRef return _provider.deadLetters();

    public function dispatchers() : Dispatchers return _dispatchers;

    public function eventStream() : EventStream return _provider.eventStream();

    public function settings() : Settings return _provider.settings();

    public function scheduler() : Scheduler return _scheduler;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _provider;

    @:allow(funk.actors)
    @:allow(funk.actors.events)
    private function systemActorOf(props : Props, name : String) : ActorRef {
        var systemGuardian = _provider.systemGuardian();
        return if (AnyTypes.isInstanceOf(systemGuardian, LocalActorRef)) {
            var local : LocalActorRef = cast systemGuardian;
            local.underlying().attachChild(props, name);
        } else {
            Funk.error(IllegalOperationError());
        }
    }

    @:allow(funk.actors)
    @:allow(funk.actors.events)
    private function deadLetterMailbox() : Mailbox {
        var deadLetters = _provider.deadLetters();
        return if (AnyTypes.isInstanceOf(deadLetters, LocalActorRef)) {
            var local : LocalActorRef = cast deadLetters;
            local.underlying().mailbox();
        } else {
            Funk.error(IllegalOperationError());
        }
    }

    @:allow(funk.actors)
    @:allow(funk.actors.events)
    private function deadLetterQueue() : MessageQueue {
        var deadLetters = _provider.deadLetters();
        return if (AnyTypes.isInstanceOf(deadLetters, LocalActorRef)) {
            var local : LocalActorRef = cast deadLetters;
            local.underlying().mailbox().messageQueue();
        } else {
            Funk.error(IllegalOperationError());
        }
    }

    public function toString() return '[ActorSystem]';

    public function printTree() : String {
        function printNode(node : ActorRef, indent : String) : String {
            return switch(node) {
                case _ if(AnyTypes.isInstanceOf(node, LocalActorRef)):
                    var local : LocalActorRef = cast node;
                    var buffer = '';
                    buffer += indent.isEmpty() ? '-> ' : indent.dropRight(1) + '|-> ';
                    buffer += '${node.path().name()} actorRef=\'${AnyTypes.getSimpleName(local)}\' ';

                    var cell = local.underlying();
                    buffer += switch(cell) {
                        case _ if(cell.actor().toBool()): 'actor=\'${AnyTypes.getSimpleName(cell.actor())}\'';
                        case _ if(!cell.actor().toBool()): 'null';
                        case _:  AnyTypes.getSimpleName(cell);
                    }

                    buffer += switch(cell) {
                        case _ if(cell.actor().toBool()): ' status=\'${cell.mailbox().status()}\'';
                        case _: '';
                    }

                    buffer += ' ';

                    var refs = cell.childrenRefs();
                    var children = refs.children();
                    buffer += switch(refs) {
                        case _ if(AnyTypes.isInstanceOf(refs, TerminatingChildrenContainer)):
                            'Terminating(userRequest=\'${refs.isNormal()}\') ';
                        case _ if(AnyTypes.isInstanceOf(refs, TerminatedChildrenContainer)):
                            'Terminated ';
                        case _ if(AnyTypes.isInstanceOf(refs, NormalChildrenContainer)):
                            'numChildren=\'${children.size()}\' children';
                        case _: AnyTypes.getName(refs);
                    }

                    var isEmpty = children.isEmpty();
                    buffer += isEmpty ? '' : '\n';
                    children.foreach(function(child) {
                        buffer += printNode(child, '$indent  |');
                    });
                    buffer;

                case _: '$indent ${node.path().name()} ${AnyTypes.getName(node)}';

            }
        }

        return '\n${printNode(actorFor(new RelativeActorPath("/user")).get(), "")}';
    }
}
