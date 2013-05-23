package ;

import funk.reactives.Process;
import funk.types.Any;
import funk.types.Option;

class Performance01 {

    public function new() {
    }

    public static function main() {
        trace('Start');

        Process.start(Performance01.run, 2000);
    }

    public static function run() : Void {
        var t = Process.stamp();

        var a = true;
        for (i in 0...99999) {
            a = a && AnyTypes.toBool(Some(1));
        }

        trace((Process.stamp() - t) / 1000 + ' seconds');
        trace(a);
    }
}
