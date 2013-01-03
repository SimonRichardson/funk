package funk.net.http;

import funk.Funk;
import funk.net.http.HttpMethod;
import funk.net.http.UriRequest;
import funk.reactive.Stream;
import funk.types.Deferred;
import funk.types.Promise;
import funk.types.Option;

using funk.net.http.extensions.UriRequests;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;

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

        _statusStream = Streams.identity(None);
        _statusStream.emit(None);

        _loader.onStatus = function (status : Int) {
            _statusStream.emit(status.toHttpStatusCode().toOption());
        };
        _loader.onData = function (data : String) {
            _deferred.resolve(data);
        };
        _loader.onError = function (error : String) {
            _deferred.reject(HttpError(Std.format("$error for url ${_request.uri()}"));
        };
    }

    public function load(method : HttpMethod) : Promise<String> {
        var request = switch (method) {
            case Get: false;
            case Post: true;
            default: Funk.error(IllegalOperationError("HttpMethod not supported"));
        }

        try {
            _loader.request(request);
        } catch (error : Dynamic) {
            _deferred.reject(HttpError(Std.format("Error at: ${Std.string(error)}")));
        }

        return _deferred.promise();
    }
}
