package funk.net.http;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.immutable.List;
import funk.net.http.UriRequest;
import funk.reactive.Stream;
import funk.types.Deferred;
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

#if js
@:expose('funk.net.http.JsonpLoader')
class JsonpLoader {

    public static var requests : Dynamic = {};

    public static var requestSeed : Int = Math.floor(Math.random() * 2147483647);

    public static var requestCount : Int = 0;

    private var _request : UriRequest;

    private var _deferred : Deferred<String>;

    private var _states : Collection<State<String>>;

    private var _statusStream : Stream<Option<HttpStatusCode>>;

    public function new(request : UriRequest) {
        _request = request;

        var requestCallback = Std.format("jsonp_callback_${requestSeed + requestCount++}");


        _deferred = new Deferred();
        _states = _deferred.states();

        _statusStream = Streams.identity(None);
        _statusStream.dispatch(None);
    }

    public function start(method : HttpMethod) : Promise<String> {
        var promise = _deferred.promise();

        if (_states.contains(Aborted)) {
            return promise;
        }

        switch (method) {
            case Get:
            default: Funk.error(IllegalOperationError("${Std.string(method)} not supported"));
        };

        try {

        } catch (error : Dynamic) {
            _deferred.reject(HttpError(Std.format("Error at: ${Std.string(error)}")));
        }

        return promise;
    }

    public function stop() : Promise<String> {
        _deferred.abort();

        return _deferred.promise();
    }

    public function status() : Stream<Option<HttpStatusCode>> {
        return _statusStream;
    }
}
#end
