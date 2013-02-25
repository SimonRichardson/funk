package funk.net.http.extensions;

import funk.collections.immutable.List;
import funk.collections.immutable.Map;
import funk.io.http.Loader;
import funk.io.http.MimeType;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpResponse;
import funk.net.http.UriRequest;
import funk.types.Option;
import funk.types.Promise;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.Lists;
using funk.io.http.extensions.Loaders;
using funk.types.extensions.Tuples2;

class UriRequests {

    public static function headers(request : UriRequest) : Option<List<HttpHeader>> {
        return switch(request) {
            case RequestWithHeaders(uri, headers):
                headers.isEmpty() ? None : Some(headers);
            default:
                None;
        }
    }

    public static function uri(request : UriRequest) : String {
        return switch (request) {
            case Request(value): value;
            case RequestWithHeaders(value, _): value;
        }
    }

    public static function fromUri(value : String) : UriRequest {
        return Request(value);
    }

    public static function fromUriWithHeaders(value : String, headers : List<HttpHeader>) : UriRequest {
        return RequestWithHeaders(value, headers);
    }

    public static function fromUriWithParameters(   value : String,
                                                    parameters : Map<String, Option<String>>
                                                    ) : UriRequest {
        // TODO (Simon) : Work out if the uri has already got parameters
        var uri = '${value}?';

        parameters.foreach(function(tuple) {
            switch(tuple._2()) {
                case Some(val): uri += '${tuple._1()}=${val}&';
                case None: uri += '${tuple._1()}&';
            };
        });

        if(uri.lastIndexOf("&") == uri.length - 1) {
            uri = uri.substr(0, uri.length - 1);
        }

        return Request(uri);
    }

    public static function get<T>(request : UriRequest, ?type : MimeType = null) : Promise<HttpResponse<T>> {
        return request.loader(type).start(Get);
    }

    public static function post<T>(request : UriRequest, ?type : MimeType = null) : Promise<HttpResponse<T>> {
        return request.loader(type).start(Post);
    }
}
