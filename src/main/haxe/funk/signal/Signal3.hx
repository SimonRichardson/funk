package funk.signal;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function3;
import funk.types.Option;
import funk.types.extensions.Functions3;
import funk.types.extensions.Options;
import funk.signal.Signal;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Functions3;
using funk.types.extensions.Options;

interface ISignal3<T1, T2, T3> implements ISignal {

	function add(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>>;

	function addOnce(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>>;

	function remove(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>>;

	function dispatch(value0 : T1, value1 : T2, value2 : T3) : Void;
}

class Signal3<T1, T2, T3> extends Signal, implements ISignal3<T1, T2, T3> {

	private var _list : List<Slot3<T1, T2, T3>>;

	public function new() {
		super();

		_list = Nil;
	}

	public function add(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>> {
		return registerListener(func, true);
	}

	public function remove(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>> {
		var o = _list.find(function(s : Slot3<T1, T2, T3>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		_list = _list.filterNot(function(s : Slot3<T1, T2, T3>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil;
	}

	public function dispatch(value0 : T1, value1 : T2, value2 : T3) : Void {
		var slots = _list;
		while(slots.nonEmpty()) {
        	slots.head().execute(value0, value1, value2);
        	slots = slots.tail();
      	}
	}

	private function registerListener(	func : Function3<T1, T2, T3, Void>,
										once : Bool) : Option<Slot3<T1, T2, T3>> {

		if(registrationPossible(func, once)) {
			var slot : Slot3<T1, T2, T3> = new Slot3<T1, T2, T3>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : Slot3<T1, T2, T3>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});
	}

	private function registrationPossible(func : Function3<T1, T2, T3, Void>, once : Bool) : Bool {
		if(!_list.nonEmpty()) {
			return true;
		}

		var slot = _list.find(function(s : Slot3<T1, T2, T3>) : Bool {
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

class Slot3<T1, T2, T3> extends Slot {

	public var listener(dynamic, never) : Function3<T1, T2, T3, Void>;

	private var _listener : Function3<T1, T2, T3, Void>;

	private var _signal : ISignal3<T1, T2, T3>;

	public function new(	signal : ISignal3<T1, T2, T3>,
							listener : Function3<T1, T2, T3, Void>,
							once : Bool) {
		super();

		_signal = signal;
		_listener = listener;

		this.once = once;
	}

	public function execute(value0 : T1, value1 : T2, value2 : T3) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1, value2);
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function get_listener() : Function3<T1, T2, T3, Void> {
		return _listener;
	}
}

