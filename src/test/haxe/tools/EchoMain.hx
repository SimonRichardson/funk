package tools;

import haxe.Json;
import neko.Lib;
import neko.Web;
import neko.vm.Thread;

class EchoMain {

    public static function main() {
        //var valid = true;
        //var thead = Thread.create(function() {
        //    while(valid) {
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
        //   }
        // /});
    }
}
