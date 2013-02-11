package tools;

import neko.io.File;
import haxe.io.Output;
import haxe.Json;
import neko.Lib;
import neko.Web;
import neko.vm.Thread;

enum Type {
    TText;
    TJson;
    TXml;
    THtml;
}

class EchoMain {

    private static var out : Output;

    public static function main() {
        var map = new Hash<String>();
        var response = "";
        var type = TText;

        var params = Web.getParams();
        for (i in params.keys()) {
            if (i == "callback") {
                response = params.get(i);
            } else if(i == "type") {
                type = switch(params.get(i)) {
                    case "json": TJson;
                    case "xml": TXml;
                    case "html": THtml;
                    default: TText;
                }
            } else {
                map.set(i, params.get(i));
            }
        }

        var buffer = new StringBuf();
        var parsed = switch(type) {
            case TJson: Json.stringify(map);
            case TXml:
                buffer.add("<echo>");
                for (i in map.keys()) {
                    buffer.add(Std.format("<${i}>${map.get(i)}</${i}>"));
                }
                buffer.add("</echo>");
                buffer.toString();
            case TText:
                for (i in map.keys()) {
                    buffer.add(Std.format("${i}=${map.get(i)};"));
                }
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
