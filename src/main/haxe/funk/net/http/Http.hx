package funk.net.http;

import funk.Funk;
import funk.collections.immutable.List;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.UriRequest;
import funk.reactive.Stream;
import funk.types.Deferred;
import funk.types.Promise;
import funk.types.Option;

using funk.collections.immutable.extensions.Lists;
using funk.net.http.extensions.HttpHeaders;
using funk.net.http.extensions.HttpStatusCodes;
using funk.net.http.extensions.UriRequests;
using funk.net.http.extensions.Uris;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

private typedef Loader = haxe.Http;

class Http {

    private var _request : UriRequest;

    private var _loader : Loader;

    private var _deferred : Deferred<String>;

    private var _statusStream : Stream<Option<HttpStatusCode>>;

    public function new(request : UriRequest) {
        _request = request;

        _loader = new Loader(request.uri());
        _deferred = new Deferred();

        // Convert the possible headers into an option and then loop over it.
        request.headers().foreach(function (list) {
            return list.foreach(function(request : HttpHeader) {
                var tuple = request.toTuple();
                _loader.setHeader(tuple._1(), tuple._2());
            });
        });

        _statusStream = Streams.identity(None);
        _statusStream.emit(None);

        _loader.onStatus = function (status : Int) {
            _statusStream.emit(status.toHttpStatusCode().toOption());
        };
        _loader.onData = function (data : String) {
            _deferred.resolve(data);
        };
        _loader.onError = function (error : String) {
            _deferred.reject(HttpError(Std.format("$error for url ${_request.uri()}")));
        };
    }

    public function load(method : HttpMethod) : Promise<String> {
        var request = switch (method) {
            case Get: false;
            case Post: true;
            default: Funk.error(IllegalOperationError("${Std.string(method)} not supported"));
        }

        try {
            _loader.request(request);
        } catch (error : Dynamic) {
            _deferred.reject(HttpError(Std.format("Error at: ${Std.string(error)}")));
        }

        return _deferred.promise();
    }

    public function status() : Stream<Option<HttpStatusCode>> {
        return _statusStream;
    }
}
