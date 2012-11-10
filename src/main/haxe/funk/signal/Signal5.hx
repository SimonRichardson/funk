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

interface ISignal5<T1, T2, T3, T4, T5> implements ISignal {

	function add(func : Function5<T1, T2, T3, T4, T5, Void>) : IOption<ISlot5<T1, T2, T3, T4, T5>>;

	function addOnce(func : Function5<T1, T2, T3, T4, T5, Void>) : IOption<ISlot5<T1, T2, T3, T4, T5>>;

	function remove(func : Function5<T1, T2, T3, T4, T5, Void>) : IOption<ISlot5<T1, T2, T3, T4, T5>>;

	function dispatch(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) : Void;
}

class Signal5<T1, T2, T3, T4, T5> extends Signal, implements ISignal5<T1, T2, T3, T4, T5> {

	private var _list : IList<ISlot5<T1, T2, T3, T4, T5>>;

	public function new() {
		super();

		_list = Nil.list();
	}

	public function add(	func : Function5<T1, T2, T3, T4, T5, Void>
							) : IOption<ISlot5<T1, T2, T3, T4, T5>> {

		return registerListener(func, false);
	}

	public function addOnce(	func : Function5<T1, T2, T3, T4, T5, Void>
								) : IOption<ISlot5<T1, T2, T3, T4, T5>> {

		return registerListener(func, true);
	}

	public function remove(	func : Function5<T1, T2, T3, T4, T5, Void>
							) : IOption<ISlot5<T1, T2, T3, T4, T5>> {

		var o = _list.find(function(s : ISlot5<T1, T2, T3, T4, T5>) : Bool {
			return listenerEquals(s.listener, func);
		});

		_list = _list.filterNot(function(s : ISlot5<T1, T2, T3, T4, T5>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil.list();
	}

	public function dispatch(	value0 : T1,
								value1 : T2,
								value2 : T3,
								value3 : T4,
								value4 : T5) : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute(value0, value1, value2, value3, value4);
        	slots = slots.tail;
      	}
	}

	override public function productElement(index : Int) : Dynamic {
		return _list.productElement(index);
	}

	private function listenerEquals(	func0 : Function5<T1, T2, T3, T4, T5, Void>,
										func1 : Function5<T1, T2, T3, T4, T5, Void>) : Bool {
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

	private function registerListener(	func : Function5<T1, T2, T3, T4, T5, Void>,
										once : Bool) : IOption<ISlot5<T1, T2, T3, T4, T5>> {

		if(registrationPossible(func, once)) {
			var slot : ISlot5<T1, T2, T3, T4, T5> = new Slot5<T1, T2, T3, T4, T5>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot).toInstance();
		}

		return _list.find(function(s : ISlot5<T1, T2, T3, T4, T5>) : Bool {
			return listenerEquals(s.listener, func);
		});
	}

	private function registrationPossible(	func : Function5<T1, T2, T3, T4, T5, Void>,
											once : Bool) : Bool {
		if(!_list.nonEmpty) {
			return true;
		}

		var slot = _list.find(function(s : ISlot5<T1, T2, T3, T4, T5>) : Bool {
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

	override private function get_productPrefix() : String {
		return "Signal5";
	}
}

interface ISlot5<T1, T2, T3, T4, T5> implements ISlot {

	var listener(dynamic, never) : Function5<T1, T2, T3, T4, T5, Void>;

	function execute(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value : T5) : Void;
}

class Slot5<T1, T2, T3, T4, T5> extends Slot, implements ISlot5<T1, T2, T3, T4, T5> {

	public var listener(dynamic, never) : Function5<T1, T2, T3, T4, T5, Void>;

	private var _listener : Function5<T1, T2, T3, T4, T5, Void>;

	private var _signal : ISignal5<T1, T2, T3, T4, T5>;

	public function new(	signal : ISignal5<T1, T2, T3, T4, T5>,
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

	public function get_listener() : Function5<T1, T2, T3, T4, T5, Void> {
		return _listener;
	}
}

