package funk.reactive;

import funk.Funk;
import funk.option.Option;
import funk.reactive.Process;

import massive.munit.Assert;

private typedef ProcessTypeDef = {
	var start : Function0<Void> -> Float -> Option<Task>;
	var stop : Function1<Option<Task>, Option<Task>>;
	var stamp : Function0<Float>;
}

class ProcessAsyncBase {

	private var _stamp : Float;

	private var _tasks : Array<Task>;

	private var _process : ProcessTypeDef;

	@Before
	public function setup() : Void {
		_stamp = 0;
		_tasks = [];

		_process = {
			start : Process.start,
			stop : Process.stop,
			stamp : Process.stamp
		};

		Process.start = function(func : Function0<Void>, time : Float) : Option<Task> {
			return if(func != null && time > 0) {
				var task = new Task(func, _stamp + time);

				_tasks.push(task);

				Some(task);
			} else {
				None;
			}
		};
		Process.stop = function(task : Option<Task>) : Option<Task> {
			switch(task) {
				case Some(value):
					value.stop();
					_tasks.remove(value);
				case None:
			}
			return None;
		};
		Process.stamp = function() : Float {
			return _stamp;
		};
	}

	@After
	public function tearDown() : Void {
		_stamp = 0;
		_tasks = [];

		Process.start = _process.start;
		Process.stop = _process.stop;
		Process.stamp = _process.stamp;
	}

	private function advanceProcessBy(time : Float, ?callAssert : Bool = true) : Void {
		var start = Std.int(_stamp);

		if (callAssert) {
			assertTaskExistsAt(start + time);
		}

		for(delta in start...Std.int(start + time + 1)) {
			_stamp = delta;

			var tasks = [].concat(_tasks);
			for(task in tasks) {
				if (task.time == _stamp) {
					task.func();
					_tasks.remove(task);
				}
			}
		}
	}

	private function advanceProcessByWithIncrements(time : Float, increments : Int) : Void {
		for(i in 0...increments) {
			advanceProcessBy(time);
		}
	}

	private function assertTaskExistsAt(time : Float) : Void {
		var found = false;
		for(task in _tasks) {
			if(task.time == time) {
				found = true;
				break;
			}
		}

		if(!found) {
			trace(_tasks);
			Assert.fail("Expecting to find a funk.reactive.Task at time " + time + ", but none was found");
		}
	}
}
