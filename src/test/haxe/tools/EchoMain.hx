package tools;

import neko.io.File;
import haxe.io.Output;
import haxe.Json;
import neko.Lib;
import neko.Web;
import neko.vm.Thread;

class EchoMain {

    private static var out : Output;

    public static function main() {
        var map = new Hash<String>();
        var response = "";

        var params = Web.getParams();
        for (i in params.keys()) {
            if (i == "callback") {
                response = params.get(i);
            } else {
                map.set(i, params.get(i));
            }
        }

        var parsed = Json.stringify(map);
        var result = if (response != "") {
            Std.format("${response}(${parsed})");
        } else {
            parsed;
        }

        log(result);
    }

    private static function log(msg : String) : Void {
        #if output
        if (out == null) {
            out = File.write("echo.log", false);
        }
        out.writeString(msg);
        out.flush();
        #end

        Lib.println(msg);
    }
}
