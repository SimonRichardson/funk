package funk.types;

import funk.Funk;
import funk.types.Deferred;
import funk.types.Function2;
import funk.types.Option;
import funk.types.Promise;

using funk.types.extensions.Options;
using funk.types.extensions.Functions2;

class Async2<T1, T2> {

	private var _deferred : Deferred<Tuple2<T1, T2>>;

	private var _promise : Promise<Tuple2<T1, T2>>;

	public function new(func : Function2<T1, T2, Void>) {
		_deferred = new Deferred();
		_promise = _deferred.promise();
		_promise.then(function(tuple) {
			func.untuple()(tuple);
		});
	}

	public function add(value : Option<Async2<T1, T2>>) : Async2<T1, T2> {
		switch(value) {
			case Some(async): 
				_promise.then(function (value) {
					async.yield.untuple()(value);
				});
			case None:
		}
		return this;
	}

	public function yield(value0 : T1, value1 : T2) : Void {
		_deferred.resolve(tuple2(value0, value1));
	}
}
