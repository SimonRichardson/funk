package funk.signal;

import funk.errors.IllegalOperationError;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal;
import funk.signal.Slot1;
import funk.unit.Expect;

using funk.collections.immutable.Nil;
using funk.unit.Expect;

interface ISignal1<A> implements ISignal {
	
	function add(func : (A -> Void)) : ISlot1<A>;
	
	function addOnce(func : (A -> Void)) : ISlot1<A>;
	
	function remove(func : (A -> Void)) : ISlot1<A>;
	
	function dispatch(a : A) : Void;
}

class Signal1<A> extends Signal, implements ISignal1<A> {
	
	private var _list : IList<ISlot1<A>>;
	
	public function new() {
		super();
		
		_list = nil.list();
	}
	
	public function add(func : (A -> Void)) : ISlot1<A> {
		return switch(registerListener(func, false)) {
			case None: null;
			case Some(x): x;
		}
	}
	
	public function addOnce(func : (A -> Void)) : ISlot1<A> {
		return switch(registerListener(func, true)) {
			case None: null;
			case Some(x): x;
		}
	}
	
	public function remove(func : (A -> Void)) : ISlot1<A> {
		var o = _list.find(function(s : ISlot1<A>) : Bool {
			return expect(s.listener).toEqual(func);
		});
		
		return switch(o) {
			case None: null;
			case Some(x): 
				_list = _list.filterNot(function(s : ISlot1<A>) : Bool {
					return expect(s.listener).toEqual(func);
				});
				x;
		}
	}
	
	override public function removeAll() : Void {
		_list = nil.list();
	}
	
	public function dispatch(a : A) : Void {
		var slots = _list;
		while(slots.nonEmpty) {
        	slots.head.execute(a);
        	slots = slots.tail;
      	}
	}
	
	private function registerListener(func : (A -> Void), once : Bool) : Option<ISlot1<A>> {
		if(registrationPossible(func, once)) {
			var slot : ISlot1<A> = new Slot1<A>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}
		
		return _list.find(function(s : ISlot1<A>) : Bool {
			return expect(s.listener).toEqual(func);
		});
	}
	
	private function registrationPossible(func : (A -> Void), once : Bool) : Bool {
		if(!_list.nonEmpty) return true;
		
		var slot = _list.find(function(s : ISlot1<A>) : Bool {
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
