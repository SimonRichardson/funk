package funk.net.http.extensions;

import funk.net.http.HttpMethod;
import funk.net.http.HttpVersion;

class HttpMethods {

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
        return switch (value) {
            case Connect: "CONNECT";
            case Delete: "DELETE";
            case Get: "GET";
            case Head: "HEAD";
            case Options: "OPTIONS";
            case Post: "POST";
            case Put: "PUT";
            case Trace: "TRACE";
        }
    }
}
