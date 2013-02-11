package tools;

import haxe.io.Output;
import neko.io.File;
import neko.io.Process;
import neko.Lib;
import neko.vm.Thread;

class ServerMain {

    private static var out : Output;

    public static function main() {
        Thread.create(function() {
            var serverProcess : Process = null;

            try {
                serverProcess = new Process("nekotools", ["server", "-p", "1234"]);

                log("Starting nekotools server\n");
            } catch(e : Dynamic) {
                log("Unable to launch nekotools server. Please kill existing process and try again.\n");
                log(Std.string(e) + "\n");
            }

            while(true){
                log(Std.format("Time: ${Sys.cpuTime()}\n"));

                Sys.sleep(1);
            }
        });

        while(true){
            Sys.sleep(0.01);
        }
    }

    private static function log(msg : String) : Void {
        #if output
        if (out == null) {
            out = File.write("server.log", false);
        }
        out.writeString(msg);
        out.flush();
        #end

        Lib.println(msg);
    }
}
