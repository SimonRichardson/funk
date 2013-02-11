package tools;

import neko.io.File;
import haxe.io.Output;
import haxe.Json;
import neko.Lib;
import neko.Web;
import neko.vm.Thread;

enum Type {
    TJson;
    TXml;
    THtml;
}

class EchoMain {

    private static var out : Output;

    public static function main() {
        var map = new Hash<String>();
        var response = "";
        var type = "json";

        var params = Web.getParams();
        for (i in params.keys()) {
            if (i == "callback") {
                response = params.get(i);
            } else if(i == "type") {
                type = switch(params.get(i)) {
                    case "xml": TXml;
                    case "html": THtml;
                    default: TJson;
                }
            } else {
                map.set(i, params.get(i));
            }
        }

        var parsed = switch(type) {
            case TJson: Json.stringify(map);
            case TXml:
                var buffer = new StringBuf();
                buffer.add("<echo>");
                for (i in map.keys()) {
                    buffer.add("<" + i + ">" + map.get(i) + "</" + i + ">");
                }
                buffer.add("</echo>");
                buffer.toString();
            case THtml: "";
        }
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
