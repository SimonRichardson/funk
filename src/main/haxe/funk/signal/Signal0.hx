package funk.signal;

import funk.errors.IllegalOperationError;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal;
import funk.signal.Slot0;
import funk.unit.Expect;

using funk.collections.immutable.Nil;
using funk.unit.Expect;

interface ISignal0 implements ISignal {
	
	function add(func : (Void -> Void)) : ISlot0;
	
	function addOnce(func : (Void -> Void)) : ISlot0;
	
	function remove(func : (Void -> Void)) : ISlot0;
	
	function dispatch() : Void;
}

class Signal0<T> extends Signal, implements ISignal0 {
	
	private var _list : IList<ISlot0>;
	
	public function new() {
		super();
		
		_list = nil.list();
	}
	
	public function add(func : (Void -> Void)) : ISlot0 {
		return switch(registerListener(func)) {
			case None: null;
			case Some(x): x;
		}
	}
	
	public function addOnce(func : (Void -> Void)) : ISlot0 {
		return switch(registerListener(func, true)) {
			case None: null;
			case Some(x): x;
		}
	}
	
	public function remove(func : (Void -> Void)) : ISlot0 {
		var o = _list.find(function(s : ISlot0) : Bool {
			return expect(s.listener).toEqual(func);
		});
		
		return switch(o) {
			case None: null;
			case Some(x): 
				_list = _list.filterNot(function(s : ISlot0) : Bool {
					return expect(s.listener).toEqual(func);
				});
				x;
		}
	}
	
	override public function removeAll() : Void {
		_list = nil.list();
	}
	
	public function dispatch() : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute();
        	slots = slots.tail;
      	}
	}
	
	private function registerListener(func : (Void -> Void), ?once : Bool) : Option<ISlot0> {
		if(registrationPossible(func, once)) {
			var slot : ISlot0 = new Slot0(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}
		
		return _list.find(function(s : ISlot0) : Bool {
			return expect(s.listener).toEqual(func);
		});
	}
	
	private function registrationPossible(func : (Void -> Void), once : Bool) : Bool {
		if(!_list.nonEmpty) return true;
		
		var slot = _list.find(function(s : ISlot0) : Bool {
			return expect(s.listener).toEqual(func);
		});
		
		return switch(slot) {
			case None: true;
			case Some(x): 
				if(x.once != once) {
					throw new IllegalOperationError('You cannot addOnce() then add() the same listener without removing the relationship first.');
				}
				false;
		}
	}
	
	override private function get_size() : Int {
		return _list.size;
	}
}
