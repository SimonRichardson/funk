package tools;

import neko.io.Process;
import neko.Lib;

class ServerMain {

    public static function main() {
        var run = null;
        run = function() {
            var serverProcess : Process = null;
            try {
                serverProcess = new Process("nekotools", ["server"]);
            } catch(e : Dynamic) {
                Lib.println("Unable to launch nekotools server. Please kill existing process and try again.");
                // Re-boot it.
                run();
            }
        }
    }
}
