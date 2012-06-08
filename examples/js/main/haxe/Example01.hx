package ;

import funk.signal.Signal1;

class Example01 {

	private var _signalA : ISignal1<Int>;

	public function new(){
		_signalA = new Signal1<Int>();

		trace(_signalA);

		_signalA.add(test);
		_signalA.add(test);

		_signalA.dispatch(1);
	}

	private function test(a : Int) : Void {
		trace("HERE");
	}

	public static function main(): Void {
		new Example01();
	}
}