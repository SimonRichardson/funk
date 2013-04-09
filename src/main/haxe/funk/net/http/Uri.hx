package funk.net.http;

using Lambda;
using funk.types.Option;
using funk.types.Tuple2;
using funk.types.extensions.Strings;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

class UriTypes {

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
                                    case Some(v3): Some('$v0://$v1:$v2$v3');
                                    case _: Some('$v0://$v1:$v2');
                                }
                            case _:
                                switch(parts.path) {
                                    case Some(v3): Some('$v0://$v1$v3');
                                    case _: Some('$v0://$v1');
                                }
                        }
                    case _: None;
                }
            case _:
                switch(parts.host) {
                    case Some(v1):
                        switch(parts.port) {
                            case Some(v2):
                                switch(parts.path) {
                                    case Some(v3): Some('$v1:$v2$v3');
                                    case _: Some('$v1:$v2');
                                }
                            case _:
                                switch(parts.path) {
                                    case Some(v3): Some('$v1$v3');
                                    case _: Some('$v1');
                                }
                        }
                    case _: None;
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
                            case Some(top): Some('$sub.$domain.$top');
                            case _: Some('$sub.$domain');
                        }
                    case _: Some(sub);
                }
            case _:
                switch(match(uri(request), 5)) {
                    case Some(domain):
                        switch(match(uri(request), 6)) {
                            case Some(top): Some('$domain.$top');
                            case _: Some('$domain');
                        }
                    case _: None;
                }
        }
    }

    public static function port(request : UriRequest) : Option<String> return match(uri(request), 7);

    public static function path(request : UriRequest) : Option<String> {
        return switch(match(uri(request), 8)) {
            case Some(path):
                switch(match(uri(request), 9)) {
                    case Some(file): Some('$path$file');
                    case _: Some(path);
                }
            case _:
                switch(match(uri(request), 9)) {
                    case Some(file): Some('$file');
                    case _: None;
                }
        }
    }

    public static function parameters(request : UriRequest) : Map<String, Option<String>> {
        var map = Empty;

        // TODO (Simon) : This seems weak
        var opt = match(uri(request), 10);
        opt.foreach(function(raw) {
            var each = raw.split("&");
            each.iter(function(value) {
                var parts = value.split("=");
                var l = parts[0];
                var r : Option<String> = if(parts.length < 1 || parts[1] == null || parts[1].isEmptyOrBlank()) None;
                else Some(parts[1]);

                map = map.add(l, r);
            });
        });

        return map;
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
