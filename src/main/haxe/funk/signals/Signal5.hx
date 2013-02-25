package funk.signals;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function5;
import haxe.ds.Option;
import funk.types.extensions.Functions5;
import funk.types.extensions.Options;
import funk.signals.Signal;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Functions5;
using funk.types.extensions.Options;

interface ISignal5<T1, T2, T3, T4, T5> {

	function add(func : Function5<T1, T2, T3, T4, T5, Void>) : Option<Slot5<T1, T2, T3, T4, T5>>;

	function addOnce(func : Function5<T1, T2, T3, T4, T5, Void>) : Option<Slot5<T1, T2, T3, T4, T5>>;

	function remove(func : Function5<T1, T2, T3, T4, T5, Void>) : Option<Slot5<T1, T2, T3, T4, T5>>;

	function dispatch(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) : Void;
}

class Signal5<T1, T2, T3, T4, T5> extends Signal {

	private var _list : List<Slot5<T1, T2, T3, T4, T5>>;

	public function new() {
		super();

		_list = Nil;
	}

	public function add(	func : Function5<T1, T2, T3, T4, T5, Void>
							) : Option<Slot5<T1, T2, T3, T4, T5>> {

		return registerListener(func, false);
	}

	public function addOnce(	func : Function5<T1, T2, T3, T4, T5, Void>
								) : Option<Slot5<T1, T2, T3, T4, T5>> {

		return registerListener(func, true);
	}

	public function remove(	func : Function5<T1, T2, T3, T4, T5, Void>
							) : Option<Slot5<T1, T2, T3, T4, T5>> {

		var o = _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		_list = _list.filterNot(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil;
	}

	public function dispatch(	value0 : T1,
								value1 : T2,
								value2 : T3,
								value3 : T4,
								value4 : T5) : Void {
		var slots = _list;
		while(slots.nonEmpty()) {
        	slots.head().execute(value0, value1, value2, value3, value4);
        	slots = slots.tail();
      	}
	}

	private function registerListener(	func : Function5<T1, T2, T3, T4, T5, Void>,
										once : Bool) : Option<Slot5<T1, T2, T3, T4, T5>> {

		if(registrationPossible(func, once)) {
			var slot : Slot5<T1, T2, T3, T4, T5> = new Slot5<T1, T2, T3, T4, T5>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});
	}

	private function registrationPossible(	func : Function5<T1, T2, T3, T4, T5, Void>,
											once : Bool) : Bool {
		if(!_list.nonEmpty()) {
			return true;
		}

		var slot = _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
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

class Slot5<T1, T2, T3, T4, T5> extends Slot {

	public var listener(dynamic, never) : Function5<T1, T2, T3, T4, T5, Void>;

	private var _listener : Function5<T1, T2, T3, T4, T5, Void>;

	private var _signal : Signal5<T1, T2, T3, T4, T5>;

	public function new(	signal : Signal5<T1, T2, T3, T4, T5>,
							listener : Function5<T1, T2, T3, T4, T5, Void>,
							once : Bool) {
		super();

		_signal = signal;
		_listener = listener;

		this.once = once;
	}

	public function execute(	value0 : T1,
								value1 : T2,
								value2 : T3,
								value3 : T4,
								value4 : T5) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1, value2, value3, value4);
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function get_listener() : Function5<T1, T2, T3, T4, T5, Void> {
		return _listener;
	}
}

