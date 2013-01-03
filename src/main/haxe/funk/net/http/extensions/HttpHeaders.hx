package funk.net.http.extensions;

import funk.types.extensions.Strings;

class HttpHeaders {

    public static function toHttpVersion(value : HttpHeader) : HttpVersion {
        return null;
    }

    public static function toString(value : HttpHeader) : String {
        return switch (value) {
            case Request(request):
                switch (request) {
                    default:
                        var name = Std.string(request);
                        Strings.camelCaseToDashes(name);
                }
            case Response(response):
                switch (response) {
                    default:
                        var name = Std.string(request);
                        Strings.camelCaseToDashes(name);
                }
        }
    }
}
