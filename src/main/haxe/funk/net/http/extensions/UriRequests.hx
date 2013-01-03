package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.UriRequest;

using funk.collections.immutable.extensions.Lists;

class UriRequests {

    public static function uri(request : UriRequest) : String {
        return Type.enumParameters(request)[0];
    }

    public static function headers(request : UriRequest) : Option<List> {
        return switch(request) {
            case RequestWithHeaders(uri, headers):
                headers.isEmpty() ? None : Some(headers);
            default:
                None;
        }
    }

    public static function fromUri(value : String) : UriRequest {
        return Request(value);
    }

    public static function fromUriWithHeaders(value : String, headers : List<HttpHeader>) : UriRequest {
        return RequestWithHeaders(value, headers);
    }

    public static function connect<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Connect);
    }

    public static function delete<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Delete);
    }

    public static function get<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Get);
    }

    public static function head<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Head);
    }

    public static function options<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Options);
    }

    public static function post<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Post);
    }

    public static function put<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Put);
    }

    public static function trace<T>(request : UriRequest) : Promise<T> {
        var http = new Http(request);
        return http.load(Trace);
    }
}
