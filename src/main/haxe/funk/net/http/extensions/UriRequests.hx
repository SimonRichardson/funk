package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.io.http.UriLoader;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpResponse;
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

    public static function get(request : UriRequest) : Promise<HttpResponse<String>> {
        var http = new UriLoader(request, function(value) {
            return value;
        });
        return http.start(Get);
    }

    public static function post(request : UriRequest) : Promise<HttpResponse<String>> {
        var http = new UriLoader(request, function(value) {
            return value;
        });
        return http.start(Post);
    }
}
