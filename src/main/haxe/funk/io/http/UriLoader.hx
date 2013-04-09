package funk.io.http;

import funk.Funk;
import funk.net.http.HttpMethod;
import funk.net.http.HttpResponse;
import funk.futures.Deferred;
import funk.futures.Promise;
import funk.types.Function1;
import haxe.Http;

using StringTools;
using funk.net.http.HttpHeader;
using funk.net.http.UriRequest;
using funk.net.http.Uri;
using funk.types.Option;
using funk.types.Tuple2;
using funk.types.extensions.Bools;
using funk.types.Attempt;
using funk.net.http.HttpStatusCode;
using funk.reactives.Stream;
using funk.collections.Collection;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

class UriLoader<T> {

    private var _request : UriRequest;

    private var _map : Function1<String, T>;

    private var _loader : Http;

    private var _deferred : Deferred<HttpResponse<T>>;

    private var _states : Collection<State<HttpResponse<T>>>;

    private var _statusStream : Stream<Option<HttpStatusCode>>;

    public function new(request : UriRequest, map : Function1<String, T>) {
        _request = request;
        _map = map;

        var url = switch(request.url()) {
            case Some(value): value;
            case _: Funk.error(HttpError("Invalid UriRequest"));
        };

        _loader = new Http(url);
        _deferred = new Deferred();
        _states = _deferred.states();

        request.parameters().foreach(function (tuple : Tuple2<String, Option<String>>) {
            _loader.setParameter(tuple._1().urlEncode(), switch (tuple._2()) {
                case Some(value): value.urlEncode();
                case _: "";
            });
        });

        // Convert the possible headers into an option and then loop over it.
        request.headers().foreach(function (list) {
            list.foreach(function(request : HttpHeader) {
                var tuple = request.toTuple();
                _loader.setHeader(tuple._1().urlEncode(), tuple._2().urlEncode());
            });
        });

        _statusStream = StreamTypes.identity(None);
        _statusStream.dispatch(None);

        // Grab the last status value
        var statusValue = None;
        _statusStream.values().foreach(function (opt) statusValue = opt);

        _loader.onStatus = function (status : Int) {
            // http://en.wikipedia.org/wiki/Same_origin_policy
            if (status == 0) _deferred.reject(HttpError('SecurityError: "Same Origin Policy" at "${_request.uri()}"'));
            else _statusStream.dispatch(status.toHttpStatusCode().toOption());
        };
        _loader.onData = function (data : String) {
            if (_states.contains(Aborted).not()) {
                _deferred.resolve({
                    code: statusValue,
                    body: Some(_map(data)),
                    headers: Nil
                });
            }
        };
        _loader.onError = function (error : String) {
            _statusStream.dispatch(Some(HttpClientError(Failure)));
            _deferred.reject(HttpError('$error for url ${_request.uri()}'));
        };
    }

    public function start(method : HttpMethod) : Promise<HttpResponse<T>> {
        var promise = _deferred.promise();

        if (_states.contains(Aborted)) return promise;

        var request = switch (method) {
            case Get: false;
            case Post: true;
            // TODO (Simon) : Work out other methods.
            case _: Funk.error(IllegalOperationError('${Std.string(method)} not supported'));
        };

        try _loader.request(request) catch (error : Dynamic) {
            _deferred.reject(HttpError('Error at: ${Std.string(error)}'));
        }

        return promise;
    }

    public function stop() : Promise<HttpResponse<T>> {
        _deferred.abort();

        return _deferred.promise();
    }

    public function status() : Stream<Option<HttpStatusCode>> {
        return _statusStream;
    }
}
