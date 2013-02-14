package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.io.http.Loader;
import funk.io.http.MimeType;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpResponse;
import funk.net.http.UriRequest;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;
using funk.io.http.extensions.Loaders;

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

    public static function get<T>(request : UriRequest, ?type : MimeType = null) : Promise<HttpResponse<T>> {
        return request.loader(type).start(Get);
    }

    public static function post<T>(request : UriRequest, ?type : MimeType = null) : Promise<HttpResponse<T>> {
        return request.loader(type).start(Post);
    }
}
