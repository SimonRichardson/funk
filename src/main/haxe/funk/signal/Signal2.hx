package funk.signal;

import funk.errors.IllegalOperationError;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal;
import funk.signal.Slot2;
import funk.unit.Expect;

using funk.collections.immutable.Nil;
using funk.unit.Expect;

interface ISignal2<A, B> implements ISignal {
	
	function add(func : (A -> B -> Void)) : ISlot2<A, B>;
	
	function addOnce(func : (A -> B -> Void)) : ISlot2<A, B>;
	
	function remove(func : (A -> B -> Void)) : ISlot2<A, B>;
	
	function dispatch(a : A, b : B) : Void;
}

class Signal2<A, B> extends Signal, implements ISignal2<A, B> {
	
	private var _list : IList<ISlot2<A, B>>;
	
	public function new() {
		super();
		
		_list = nil.list();
	}
	
	public function add(func : (A -> B -> Void)) : ISlot2<A, B> {
		return switch(registerListener(func, false)) {
			case None: null;
			case Some(x): x;
		}
	}
	
	public function addOnce(func : (A -> B -> Void)) : ISlot2<A, B> {
		return switch(registerListener(func, true)) {
			case None: null;
			case Some(x): x;
		}
	}
	
	public function remove(func : (A -> B -> Void)) : ISlot2<A, B> {
		var o = _list.find(function(s : ISlot2<A, B>) : Bool {
			return expect(s.listener).toEqual(func);
		});
		
		return switch(o) {
			case None: null;
			case Some(x): 
				_list = _list.filterNot(function(s : ISlot2<A, B>) : Bool {
					return expect(s.listener).toEqual(func);
				});
				x;
		}
	}
	
	override public function removeAll() : Void {
		_list = nil.list();
	}
	
	public function dispatch(a : A, b : B) : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute(a, b);
        	slots = slots.tail;
      	}
	}
	
	private function registerListener(func : (A -> B -> Void), once : Bool) : Option<ISlot2<A, B>> {
		if(registrationPossible(func, once)) {
			var slot : ISlot2<A, B> = new Slot2<A, B>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}
		
		return _list.find(function(s : ISlot2<A, B>) : Bool {
			return expect(s.listener).toEqual(func);
		});
	}
	
	private function registrationPossible(func : (A -> B -> Void), once : Bool) : Bool {
		if(!_list.nonEmpty) return true;
		
		var slot = _list.find(function(s : ISlot2<A, B>) : Bool {
			return expect(s.listener).toEqual(func);
		});
		
		return switch(slot) {
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
