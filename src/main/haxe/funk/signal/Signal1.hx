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

interface ISignal1<T1> implements ISignal {

	function add(func : Function1<T1, Void>) : IOption<ISlot1<T1>>;

	function addOnce(func : Function1<T1, Void>) : IOption<ISlot1<T1>>;

	function remove(func : Function1<T1, Void>) : IOption<ISlot1<T1>>;

	function dispatch(value0 : T1) : Void;
}

class Signal1<T1> extends Signal, implements ISignal1<T1> {

	private var _list : IList<ISlot1<T1>>;

	public function new() {
		super();

		_list = Nil.list();
	}

	public function add(func : Function1<T1, Void>) : IOption<ISlot1<T1>> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function1<T1, Void>) : IOption<ISlot1<T1>> {
		return registerListener(func, true);
	}

	public function remove(func : Function1<T1, Void>) : IOption<ISlot1<T1>> {
		var o = _list.find(function(s : ISlot1<T1>) : Bool {
			return listenerEquals(s.listener, func);
		});

		_list = _list.filterNot(function(s : ISlot1<T1>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil.list();
	}

	public function dispatch(value0 : T1) : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute(value0);
        	slots = slots.tail;
      	}
	}

	override public function productElement(index : Int) : Dynamic {
		return _list.productElement(index);
	}

	private function listenerEquals(	func0 : Function1<T1, Void>,
										func1 : Function1<T1, Void>) : Bool {
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

	private function registerListener(	func : Function1<T1, Void>,
										once : Bool) : IOption<ISlot1<T1>> {

		if(registrationPossible(func, once)) {
			var slot : ISlot1<T1> = new Slot1<T1>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot).toInstance();
		}

		return _list.find(function(s : ISlot1<T1>) : Bool {
			return listenerEquals(s.listener, func);
		});
	}

	private function registrationPossible(func : Function1<T1, Void>, once : Bool) : Bool {
		if(!_list.nonEmpty) {
			return true;
		}

		var slot = _list.find(function(s : ISlot1<T1>) : Bool {
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

interface ISlot1<T1> implements ISlot {

	var listener(dynamic, never) : Function1<T1, Void>;

	function execute(value0 : T1) : Void;
}

class Slot1<T1> extends Slot, implements ISlot1<T1> {

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

	public function get_listener() : Function1<T1, Void> {
		return _listener;
	}
}

