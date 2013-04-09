package funk.net.http;

enum HttpMethod {
    Connect;
    Delete;
    Get;
    Head;
    Options;
    Post;
    Put;
    Trace;
}

class HttpMethodTypes {

    public static function toHttpVersion(value : HttpMethod) : HttpVersion {
        return switch (value) {
            case Connect: Http("1.1");
            case Delete: Http("1.1");
            case Get: Http("1.0");
            case Head: Http("1.0");
            case Options: Http("1.1");
            case Post: Http("1.0");
            case Put: Http("1.1");
            case Trace: Http("1.1");
        }
    }

    public static function toString(value : HttpMethod) : String {
        return Std.string(value).toUpperCase();
    }
}
