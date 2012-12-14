package funk.signals;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function1;
import funk.types.Option;
import funk.types.extensions.Functions1;
import funk.types.extensions.Options;
import funk.signals.Signal;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Functions1;
using funk.types.extensions.Options;

interface ISignal1<T1> implements ISignal {

	function add(func : Function1<T1, Void>) : Option<Slot1<T1>>;

	function addOnce(func : Function1<T1, Void>) : Option<Slot1<T1>>;

	function remove(func : Function1<T1, Void>) : Option<Slot1<T1>>;

	function dispatch(value0 : T1) : Void;
}

class Signal1<T1> extends Signal, implements ISignal1<T1> {

	private var _list : List<Slot1<T1>>;

	public function new() {
		super();

		_list = Nil;
	}

	public function add(func : Function1<T1, Void>) : Option<Slot1<T1>> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function1<T1, Void>) : Option<Slot1<T1>> {
		return registerListener(func, true);
	}

	public function remove(func : Function1<T1, Void>) : Option<Slot1<T1>> {
		var o = _list.find(function(s : Slot1<T1>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		_list = _list.filterNot(function(s : Slot1<T1>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil;
	}

	public function dispatch(value0 : T1) : Void {
		var slots = _list;
		while(slots.nonEmpty()) {
        	slots.head().execute(value0);
        	slots = slots.tail();
      	}
	}

	private function registerListener(	func : Function1<T1, Void>,
										once : Bool) : Option<Slot1<T1>> {

		if(registrationPossible(func, once)) {
			var slot : Slot1<T1> = new Slot1<T1>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : Slot1<T1>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});
	}

	private function registrationPossible(func : Function1<T1, Void>, once : Bool) : Bool {
		if(!_list.nonEmpty()) {
			return true;
		}

		var slot = _list.find(function(s : Slot1<T1>) : Bool {
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

class Slot1<T1> extends Slot {

	public var listener(dynamic, never) : Function1<T1, Void>;

	private var _listener : Function1<T1, Void>;

	private var _signal : ISignal1<T1>;

	public function new(signal : ISignal1<T1>, listener : Function1<T1, Void>, once : Bool) {
		super();

		_signal = signal;
		_listener = listener;

		this.once = once;
	}

	public function execute(value0 : T1) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0);
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function get_listener() : Function1<T1, Void> {
		return _listener;
	}
}

