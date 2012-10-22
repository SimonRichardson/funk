package funk.signal;

import funk.Funk;
import funk.errors.IllegalOperationError;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal;
import funk.signal.Slot2;

using funk.collections.immutable.Nil;

interface ISignal2<T1, T2> implements ISignal {

	function add(func : Function2<T1, T2, Void>) : IOption<ISlot2<T1, T2>>;

	function addOnce(func : Function2<T1, T2, Void>) : IOption<ISlot2<T1, T2>>;

	function remove(func : Function2<T1, T2, Void>) : IOption<ISlot2<T1, T2>>;

	function dispatch(value0 : T1, value1 : T2) : Void;
}

class Signal2<T1, T2> extends Signal, implements ISignal2<T1, T2> {

	private var _list : IList<ISlot2<T1, T2>>;

	public function new() {
		super();

		_list = Nil.list();
	}

	public function add(func : Function2<T1, T2, Void>) : IOption<ISlot2<T1, T2>> {
		return registerListener(func, false);
	}

	public function addOnce(func : Function2<T1, T2, Void>) : ISlot2<T1, T2> {
		return registerListener(func, true);
	}

	public function remove(func : Function2<T1, T2, Void>) : ISlot2<T1, T2> {
		var o = _list.find(function(s : ISlot2<T1, T2>) : Bool {
			return listenerEquals(s.listener, func);
		});

		_list = _list.filterNot(function(s : ISlot2<T1, T2>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil.list();
	}

	public function dispatch(value0 : T1, value1 : T2) : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute(value0, value1);
        	slots = slots.tail;
      	}
	}

	override public function productElement(index : Int) : Dynamic {
		return _list.productElement(index);
	}

	private function listenerEquals(	func0 : Function2<T1, T2, Void>,
									func1 : Function2<T1, T2, Void>) : Bool {
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

	private function registerListener(	func : Function2<T1, T2, Void>,
										once : Bool) : Option<ISlot2<T1, T2>> {
		if(registrationPossible(func, once)) {
			var slot : ISlot2<T1, T2> = new Slot2<T1, T2>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : ISlot2<T1, T2>) : Bool {
			return listenerEquals(s.listener, func);
		});
	}

	private function registrationPossible(func : Function2<T1, T2, Void>, once : Bool) : Bool {
		if(!_list.nonEmpty) {
			return true;
		}

		var slot = _list.find(function(s : ISlot2<T1, T2>) : Bool {
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
