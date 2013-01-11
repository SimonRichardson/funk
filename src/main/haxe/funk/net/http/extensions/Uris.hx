package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.net.http.UriRequest;
import funk.types.Option;
import funk.types.Tuple2;

using Lambda;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;
using funk.types.extensions.Strings;

class Uris {

    public static function uri(request : UriRequest) : String {
        return Type.enumParameters(request)[0];
    }

    public static function url(request : UriRequest) : Option<String> {
        var parts = {
            protocol: protocol(request),
            host: host(request),
            port: port(request),
            path: path(request)
        };

        return switch(parts.protocol) {
            case Some(v0):
                switch(parts.host) {
                    case Some(v1):
                        switch(parts.port) {
                            case Some(v2):
                                switch(parts.path) {
                                    case Some(v3):
                                        Some(Std.format("$v0://$v1:$v2$v3"));
                                    case None:
                                        Some(Std.format("$v0://$v1:$v2"));
                                }
                            case None:
                                switch(parts.path) {
                                    case Some(v3):
                                        Some(Std.format("$v0://$v1$v3"));
                                    case None:
                                        Some(Std.format("$v0://$v1"));
                                }
                        }
                    case None:
                        None;
                }
            case None:
                switch(parts.host) {
                    case Some(v1):
                        switch(parts.port) {
                            case Some(v2):
                                switch(parts.path) {
                                    case Some(v3):
                                        Some(Std.format("$v1:$v2$v3"));
                                    case None:
                                        Some(Std.format("$v1:$v2"));
                                }
                            case None:
                                switch(parts.path) {
                                    case Some(v3):
                                        Some(Std.format("$v1$v3"));
                                    case None:
                                        Some(Std.format("$v1"));
                                }
                        }
                    case None:
                        None;
                }
        }
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
                        Some(Std.format("$path$file"));
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

        // TODO (Simon) : This seems weak
        var opt = match(uri(request), 10);
        opt.foreach(function(raw) {
            var each = raw.split("&");
            each.iter(function(value) {
                var parts = value.split("=");
                var l = parts[0];
                var r = parts.length < 1 || parts[1] == null || parts[1].isEmptyOrBlank() ? None : Some(parts[1]);
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
        return regexp.matched(index).toOption().flatMap(function (value) {
            return (value == "") ? None : Some(value);
        });
    }
}
