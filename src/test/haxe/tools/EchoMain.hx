package tools;

import neko.io.File;
import haxe.Json;
import neko.Lib;
import neko.Web;
import neko.vm.Thread;

class EchoMain {

    public static function main() {
        var out = File.write("echo.log", false);
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

        Lib.print(result);
        out.writeString(result);
        out.flush();
    }
}
