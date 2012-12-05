package funk.signal;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function0;
import funk.types.Option;
import funk.types.extensions.Functions0;
import funk.types.extensions.Options;
import funk.signal.Signal;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Functions0;
using funk.types.extensions.Options;

interface ISignal0 implements ISignal {

	function add(func : Function0<Void>) : Option<Slot0>;

	function addOnce(func : Function0<Void>) : Option<Slot0>;

	function remove(func : Function0<Void>) : Option<Slot0>;

	function dispatch() : Void;
}

class Signal0 extends Signal, implements ISignal0 {

	private var _list : List<Slot0>;

	public function new() {
		super();

		_list = Nil;
	}

	public function add(func : Function0<Void>) : Option<Slot0> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function0<Void>) : Option<Slot0> {
		return registerListener(func, true);
	}

	public function remove(func : Function0<Void>) : Option<Slot0> {
		var o = _list.find(function(s : Slot0) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		_list = _list.filterNot(function(s : Slot0) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil;
	}

	public function dispatch() : Void {
		var slots = _list;
		while(slots.nonEmpty()) {
        	slots.head().execute();
        	slots = slots.tail();
      	}
	}

	private function registerListener(func : Function0<Void>, once : Bool) : Option<Slot0> {

		if(registrationPossible(func, once)) {
			var slot : Slot0 = new Slot0(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : Slot0) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});
	}

	private function registrationPossible(func : Function0<Void>, once : Bool) : Bool {
		if(!_list.nonEmpty()) {
			return true;
		}

		var slot = _list.find(function(s : Slot0) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		return switch(slot) {
			case None: true;
			case Some(x):
				if(x.once != once) {
					Funk.error(Errors.IllegalOperationError('You cannot addOnce() then add() the same " +
					 "listener without removing the relationship first.'));
				}
				false;
		}
	}

	override public function size() : Int {
		return _list.size();
	}
}

class Slot0 extends Slot {

	public var listener(dynamic, never) : Function0<Void>;

	private var _listener : Function0<Void>;

	private var _signal : ISignal0;

	public function new(signal : ISignal0, listener : Function0<Void>, once : Bool) {
		super();

		_signal = signal;
		_listener = listener;

		this.once = once;
	}

	public function execute() : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener();
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function get_listener() : Function0<Void> {
		return _listener;
	}
}
