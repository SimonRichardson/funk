package funk.signal;

import funk.Funk;
import funk.errors.IllegalOperationError;
import funk.errors.RangeError;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal;

using funk.collections.immutable.Nil;
using funk.option.Option;

interface ISignal3<T1, T2, T3> implements ISignal {

	function add(func : Function3<T1, T2, T3, Void>) : IOption<ISlot3<T1, T2, T3>>;

	function addOnce(func : Function3<T1, T2, T3, Void>) : IOption<ISlot3<T1, T2, T3>>;

	function remove(func : Function3<T1, T2, T3, Void>) : IOption<ISlot3<T1, T2, T3>>;

	function dispatch(value0 : T1, value1 : T2, value2 : T3) : Void;
}

class Signal3<T1, T2, T3> extends Signal, implements ISignal3<T1, T2, T3> {

	private var _list : IList<ISlot3<T1, T2, T3>>;

	public function new() {
		super();

		_list = Nil.list();
	}

	public function add(func : Function3<T1, T2, T3, Void>) : IOption<ISlot3<T1, T2, T3>> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function3<T1, T2, T3, Void>) : IOption<ISlot3<T1, T2, T3>> {
		return registerListener(func, true);
	}

	public function remove(func : Function3<T1, T2, T3, Void>) : IOption<ISlot3<T1, T2, T3>> {
		var o = _list.find(function(s : ISlot3<T1, T2, T3>) : Bool {
			return listenerEquals(s.listener, func);
		});

		_list = _list.filterNot(function(s : ISlot3<T1, T2, T3>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil.list();
	}

	public function dispatch(value0 : T1, value1 : T2, value2 : T3) : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute(value0, value1, value2);
        	slots = slots.tail;
      	}
	}

	override public function productElement(index : Int) : Dynamic {
		return _list.productElement(index);
	}

	private function listenerEquals(	func0 : Function3<T1, T2, T3, Void>,
										func1 : Function3<T1, T2, T3, Void>) : Bool {
		return if(func0 == func1) {
			true;
		}
		#if js
		else if(	Reflect.hasField(func0, 'scope') &&
					Reflect.hasField(func1, 'scope') &&
					Reflect.field(func0, 'scope') == Reflect.field(func1, 'scope') &&
					Reflect.field(func0, 'method') == Reflect.field(func1, 'scope')) {
			true;
		}
		#end
		else {
			false;
		}
	}

	private function registerListener(	func : Function3<T1, T2, T3, Void>,
										once : Bool) : IOption<ISlot3<T1, T2, T3>> {

		if(registrationPossible(func, once)) {
			var slot : ISlot3<T1, T2, T3> = new Slot3<T1, T2, T3>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot).toInstance();
		}

		return _list.find(function(s : ISlot3<T1, T2, T3>) : Bool {
			return listenerEquals(s.listener, func);
		});
	}

	private function registrationPossible(func : Function3<T1, T2, T3, Void>, once : Bool) : Bool {
		if(!_list.nonEmpty) {
			return true;
		}

		var slot = _list.find(function(s : ISlot3<T1, T2, T3>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return switch(slot.toOption()) {
			case None: true;
			case Some(x):
				if(x.once != once) {
					throw new IllegalOperationError('You cannot addOnce() then add() the same " +
					 "listener without removing the relationship first.');
				}
				false;
		}
	}

	override private function get_size() : Int {
		return _list.size;
	}
}

interface ISlot3<T1, T2, T3> implements ISlot {

	var listener(dynamic, never) : Function3<T1, T2, T3, Void>;

	function execute(value0 : T1, value1 : T2, value2 : T3) : Void;
}

class Slot3<T1, T2, T3> extends Slot, implements ISlot3<T1, T2, T3> {

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

	override public function productElement(index : Int) : Dynamic {
		return switch(index){
			case 0: listener;
			default:
				throw new RangeError();
		}
	}

	override private function get_productArity() : Int {
		return 1;
	}

	public function get_listener() : Function3<T1, T2, T3, Void> {
		return _listener;
	}
}

