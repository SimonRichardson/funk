package funk.signals;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function2;
import funk.types.Option;
import funk.types.extensions.Functions2;
import funk.types.extensions.Options;
import funk.signals.Signal;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Functions2;
using funk.types.extensions.Options;

interface ISignal2<T1, T2> implements ISignal {

	function add(func : Function2<T1, T2, Void>) : Option<Slot2<T1, T2>>;

	function addOnce(func : Function2<T1, T2, Void>) : Option<Slot2<T1, T2>>;

	function remove(func : Function2<T1, T2, Void>) : Option<Slot2<T1, T2>>;

	function dispatch(value0 : T1, value1 : T2) : Void;
}

class Signal2<T1, T2> extends Signal, implements ISignal2<T1, T2> {

	private var _list : List<Slot2<T1, T2>>;

	public function new() {
		super();

		_list = Nil;
	}

	public function add(func : Function2<T1, T2, Void>) : Option<Slot2<T1, T2>> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function2<T1, T2, Void>) : Option<Slot2<T1, T2>> {
		return registerListener(func, true);
	}

	public function remove(func : Function2<T1, T2, Void>) : Option<Slot2<T1, T2>> {
		var o = _list.find(function(s : Slot2<T1, T2>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		_list = _list.filterNot(function(s : Slot2<T1, T2>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil;
	}

	public function dispatch(value0 : T1, value1 : T2) : Void {
		var slots = _list;
		while(slots.nonEmpty()) {
        	slots.head().execute(value0, value1);
        	slots = slots.tail();
      	}
	}

	private function registerListener(	func : Function2<T1, T2, Void>,
										once : Bool) : Option<Slot2<T1, T2>> {

		if(registrationPossible(func, once)) {
			var slot : Slot2<T1, T2> = new Slot2<T1, T2>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : Slot2<T1, T2>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});
	}

	private function registrationPossible(func : Function2<T1, T2, Void>, once : Bool) : Bool {
		if(!_list.nonEmpty()) {
			return true;
		}

		var slot = _list.find(function(s : Slot2<T1, T2>) : Bool {
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

class Slot2<T1, T2> extends Slot {

	public var listener(dynamic, never) : Function2<T1, T2, Void>;

	private var _listener : Function2<T1, T2, Void>;

	private var _signal : ISignal2<T1, T2>;

	public function new(	signal : ISignal2<T1, T2>,
							listener : Function2<T1, T2, Void>,
							once : Bool) {
		super();

		_signal = signal;
		_listener = listener;

		this.once = once;
	}

	public function execute(value0 : T1, value1 : T2) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1);
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function get_listener() : Function2<T1, T2, Void> {
		return _listener;
	}
}

