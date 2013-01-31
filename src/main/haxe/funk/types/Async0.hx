package funk.types;

import funk.Funk;
import funk.types.Deferred;
import funk.types.Function0;
import funk.types.Option;
import funk.types.Promise;

using funk.types.extensions.Options;

class Async0 {

	private var _deferred : Deferred<Unit>;

	private var _promise : Promise<Unit>;

	public function new(func : Function0<Void>) {
		_deferred = new Deferred();
		_promise = _deferred.promise();
		_promise.then(function(value) {
			func();
		});
	}

	public function add(value : Option<Async0>) : Async0 {
		switch(value) {
			case Some(async): 
				_promise.then(function (value) {
					async.yield();
				});
			case None:
		}
		return this;
	}

	public function yield() : Void {
		_deferred.resolve(Unit);
	}
}
