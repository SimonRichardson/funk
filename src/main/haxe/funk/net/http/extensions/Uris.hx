package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.net.http.UriRequest;
import funk.types.Option;
import funk.types.Tuple2;

using Lambda;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;

class Uris {

    public static function uri(request : UriRequest) : String {
        return Type.enumParameters(request)[0];
    }

    public static function protocol(request : UriRequest) : Option<String> {
        return match(uri(request), 1);
    }

    public static function host(request : UriRequest) : Option<String> {
        return switch(match(uri(request), 4)) {
            case Some(sub):
                switch(match(uri(request), 5)) {
                    case Some(domain):
                        switch(match(uri(request), 6)) {
                            case Some(top):
                                Some(Std.format("$sub.$domain.$top"));
                            case None:
                                Some(Std.format("$sub.$domain"));
                        }
                    case None:
                        Some(sub);
                }
            case None:
                switch(match(uri(request), 5)) {
                    case Some(domain):
                        switch(match(uri(request), 6)) {
                            case Some(top):
                                Some(Std.format("$domain.$top"));
                            case None:
                                Some(Std.format("$domain"));
                        }
                    case None:
                        None;
                }
        }
    }

    public static function port(request : UriRequest) : Option<String> {
        return match(uri(request), 7);
    }

    public static function path(request : UriRequest) : Option<String> {
        return switch(match(uri(request), 8)) {
            case Some(path):
                switch(match(uri(request), 9)) {
                    case Some(file):
                        Some(Std.format("$path/$file"));
                    case None:
                        Some(path);
                }
            case None:
                switch(match(uri(request), 9)) {
                    case Some(file):
                        Some(Std.format("$file"));
                    case None:
                        None;
                }
        }
    }

    public static function parameters(request : UriRequest) : List<Tuple2<String, Option<String>>> {
        var list = Nil;

        var opt = match(uri(request), 10);
        opt.foreach(function(raw) {
            var each = raw.split("&");
            each.iter(function(value) {
                var parts = value.split("=");
                var l = parts[0];
                var r = parts.length == 1 ? None : Some(parts[1]);
                list = list.prepend(tuple2(l, r));
            });
        });

        return list;
    }

    public static function hash(request : UriRequest) : Option<String> {
        return match(uri(request), 11);
    }

    private static function match(uri : String, index : Int) : Option<String> {
        var regexp = new EReg("(?:([^\\:]*)\\:\\/\\/)?(?:([^\\:\\@]*)(?:\\:([^\\@]*))?\\@)?(?:([^\\/\\:]*)\\.(?=[^\\.\\/\\:]*\\.[^\\.\\/\\:]*))?([^\\.\\/\\:]*)(?:\\.([^\\/\\.\\:]*))?(?:\\:([0-9]*))?(\\/[^\\?#]*(?=.*?\\/)\\/)?([^\\?#]*)?(?:\\?([^#]*))?(?:#(.*))?", "");
        regexp.match(uri);
        return regexp.matched(index).toOption();
    }
}
