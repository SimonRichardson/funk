package ;

import funk.reactive.Signals;
import funk.reactive.Streams;

class Main {

	public function new() {
		var timer = Streams.random(Signals.constant(100));
		Streams.bind(log, timer.map(function(v){
			return Std.int(v * 1000);
		}));

		// This just keeps neko open because of timer based.
		#if neko
		while(true){
			neko.Sys.sleep(1000 * 0.001);
		}
		#end
	}

	public static function main() {
		new Main();
	}

	private static function log(value) {
		trace(value);
	}
}
