package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.UriRequest;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;

class UriRequests {

    public static function headers(request : UriRequest) : Option<List<HttpHeader>> {
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

    public static function connect(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Connect);
    }

    public static function delete(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Delete);
    }

    public static function get(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Get);
    }

    public static function head(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Head);
    }

    public static function options(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Options);
    }

    public static function post(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Post);
    }

    public static function put(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Put);
    }

    public static function trace(request : UriRequest) : Promise<String> {
        var http = new Http(request);
        return http.start(Trace);
    }
}
