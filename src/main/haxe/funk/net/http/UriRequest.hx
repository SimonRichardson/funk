package funk.net.http;

import funk.Funk;
import funk.futures.Promise;
import funk.net.http.HttpHeader;
import funk.io.http.MimeType;

using funk.types.Option;
using funk.collections.immutable.List;
using funk.collections.immutable.Map;
using funk.io.http.Loader;

enum UriRequest {
    Request(uri : String);
    RequestWithHeaders(uri : String, headers : List<HttpHeader>);
}

class UriRequestTypes {

    public static function headers(request : UriRequest) : Option<List<HttpHeader>> {
        return switch(request) {
            case RequestWithHeaders(_, headers): headers.isEmpty() ? None : Some(headers);
            case _: None;
        }
    }

    public static function uri(request : UriRequest) : String {
        return switch (request) {
            case Request(value): value;
            case RequestWithHeaders(value, _): value;
        }
    }

    public static function fromUri(value : String) : UriRequest return Request(value);

    public static function fromUriWithHeaders(value : String, headers : List<HttpHeader>) : UriRequest {
        return RequestWithHeaders(value, headers);
    }

    public static function fromUriWithParameters(   value : String,
                                                    parameters : Map<String, Option<String>>
                                                    ) : UriRequest {
        if (value.indexOf('?') >= 0) Funk.error(ArgumentError('Uri already has parameters'));

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
