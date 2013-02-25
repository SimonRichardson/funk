package funk.types;

import funk.Funk;
import funk.types.Deferred;
import funk.types.Function3;
import haxe.ds.Option;
import funk.types.Promise;

using funk.types.extensions.Options;
using funk.types.extensions.Functions3;

class Async3<T1, T2, T3> {

	private var _deferred : Deferred<Tuple3<T1, T2, T3>>;

	private var _promise : Promise<Tuple3<T1, T2, T3>>;

	public function new(func : Function3<T1, T2, T3, Void>) {
		_deferred = new Deferred();
		_promise = _deferred.promise();
		_promise.then(function(tuple) {
			func.untuple()(tuple);
		});
	}

	public function add(value : Option<Async3<T1, T2, T3>>) : Async3<T1, T2, T3> {
		switch(value) {
			case Some(async): 
				_promise.then(function (value) {
					async.yield.untuple()(value);
				});
			case None:
		}
		return this;
	}

	public function yield(value0 : T1, value1 : T2, value2 : T3) : Void {
		_deferred.resolve(tuple3(value0, value1, value2));
	}
}
