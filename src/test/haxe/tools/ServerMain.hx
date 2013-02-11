package tools;

import neko.io.File;
import neko.io.Process;
import neko.Lib;
import neko.vm.Thread;

class ServerMain {

    public static function main() {
        var out = File.write("server.log", false);

        Thread.create(function() {
            var serverProcess : Process = null;

            try {
                serverProcess = new Process("nekotools", ["server", "-p", "1234"]);

                out.writeString("Starting nekotools server\n");
                out.flush();
            } catch(e : Dynamic) {
                out.writeString("Unable to launch nekotools server. Please kill existing process and try again.\n");
                out.writeString(Std.string(e) + "\n");
                out.flush();

                Lib.println("Unable to launch nekotools server. Please kill existing process and try again.");
            }

            while(true){
                out.writeString(Std.format("Time: ${Sys.cpuTime()}\n"));
                out.flush();

                Lib.println("hmm");

                Sys.sleep(1);
            }
        });

        while(true){
            Sys.sleep(0.01);
        }
    }
}
