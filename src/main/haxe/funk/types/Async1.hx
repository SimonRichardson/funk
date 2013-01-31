package funk.types;

import funk.Funk;
import funk.types.Deferred;
import funk.types.Function1;
import funk.types.Option;
import funk.types.Promise;

using funk.types.extensions.Options;
using funk.types.extensions.Functions1;

class Async1<T1> {

	private var _deferred : Deferred<Tuple1<T1>>;

	private var _promise : Promise<Tuple1<T1>>;

	public function new(func : Function1<T1, Void>) {
		_deferred = new Deferred();
		_promise = _deferred.promise();
		_promise.then(function(tuple) {
			func.untuple()(tuple);
		});
	}

	public function add(value : Option<Async1<T1>>) : Async1<T1> {
		switch(value) {
			case Some(async): 
				_promise.then(function (value) {
					async.yield.untuple()(value);
				});
			case None:
		}
		return this;
	}

	public function yield(value0 : T1) : Void {
		_deferred.resolve(tuple1(value0));
	}
}
