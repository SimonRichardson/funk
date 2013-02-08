package funk.io.http;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.immutable.List;
import funk.collections.immutable.Map;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.UriRequest;
import funk.net.http.HttpStatusCode;
import funk.reactive.Stream;
import funk.types.Deferred;
import funk.types.Function1;
import funk.types.Promise;
import funk.types.Option;
import funk.types.Tuple2;
import haxe.Http;

using funk.collections.immutable.extensions.Lists;
using funk.collections.extensions.Collections;
using funk.net.http.extensions.HttpHeaders;
using funk.net.http.extensions.HttpStatusCodes;
using funk.net.http.extensions.UriRequests;
using funk.net.http.extensions.Uris;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Attempts;
using funk.types.extensions.Bools;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class UriLoader<T> {

    private var _request : UriRequest;

    private var _map : Function1<String, T>;

    private var _loader : Http;

    private var _deferred : Deferred<T>;

    private var _states : Collection<State<T>>;

    private var _statusStream : Stream<Option<HttpStatusCode>>;

    public function new(request : UriRequest, map : Function1<String, T>) {
        _request = request;
        _map = map;

        _loader = new Http(request.uri());
        _deferred = new Deferred();
        _states = _deferred.states();

        request.parameters().foreach(function (tuple : Tuple2<String, Option<String>>) {
            _loader.setParameter(tuple._1(), switch (tuple._2()) {
                case Some(value): value;
                case None: "";
            });
        });

        // Convert the possible headers into an option and then loop over it.
        request.headers().foreach(function (list) {
            list.foreach(function(request : HttpHeader) {
                var tuple = request.toTuple();
                _loader.setHeader(tuple._1(), tuple._2());
            });
        });

        _statusStream = Streams.identity(None);
        _statusStream.dispatch(None);

        _loader.onStatus = function (status : Int) {
            if (status == 0) {
                // http://en.wikipedia.org/wiki/Same_origin_policy
                _deferred.reject(HttpError(Std.format("SecurityError: 'Same Origin Policy' at '${_request.uri()}'")));
            } else {
                _statusStream.dispatch(status.toHttpStatusCode().toOption());
            }
        };
        _loader.onData = function (data : String) {
            if (_states.contains(Aborted).not()) {
                _deferred.resolve(_map(data));
            }
        };
        _loader.onError = function (error : String) {
            _statusStream.dispatch(HttpClientError(Failure).toOption());
            _deferred.reject(HttpError(Std.format("$error for url ${_request.uri()}")));
        };
    }

    public function start(method : HttpMethod) : Promise<T> {
        var promise = _deferred.promise();

        if (_states.contains(Aborted)) {
            return promise;
        }

        var request = switch (method) {
            case Get: false;
            case Post: true;
            // TODO (Simon) : Work out other methods.
            default: Funk.error(IllegalOperationError("${Std.string(method)} not supported"));
        };

        try {
            _loader.request(request);
        } catch (error : Dynamic) {
            _deferred.reject(HttpError(Std.format("Error at: ${Std.string(error)}")));
        }

        return promise;
    }

    public function stop() : Promise<T> {
        _deferred.abort();

        return _deferred.promise();
    }

    public function status() : Stream<Option<HttpStatusCode>> {
        return _statusStream;
    }
}
