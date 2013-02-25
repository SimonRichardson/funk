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
        var map = new Map<String, String>();
        var response = "";
        var type = TText;

        var params = Web.getParams();

        Web.setReturnCode(200);

        log("Parameters : ");
        log(params.toString());

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
            } else if (i != "") {
                map.set(i, params.get(i));
            }
        }

        var buffer = new StringBuf();
        var parsed = switch(type) {
            case TJson: Json.stringify(map);
            case TXml:
                buffer.add("<echo>");
                for (i in map.keys()) {
                    buffer.add('<${i}>${map.get(i)}</${i}>');
                }
                buffer.add("</echo>");
                buffer.toString();
            case TText:
                for (i in map.keys()) {
                    buffer.add('${i}=${map.get(i)};');
                }
                buffer.toString();
            case THtml: "";
        }
        var result = if (response != "") {
            '${response}(${parsed})';
        } else {
            parsed;
        }

        log(result, true);
    }

    private static function log(msg : String, ?print : Bool = false) : Void {
        #if output
        if (out == null) {
            out = File.append("echo.log", false);
            out.writeString("\n-------------------------------\n");
            out.flush();
        }
        out.writeString(msg + "\n");
        out.flush();
        #end

        if (print) {
            Lib.println(msg);
        }
    }
}
