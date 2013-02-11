package funk.io.http;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.immutable.List;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpStatusCode;
import funk.net.http.UriRequest;
import funk.reactive.Stream;
import funk.types.Deferred;
import funk.types.Function1;
import funk.types.Promise;
import funk.types.Option;
import funk.types.Tuple2;
import haxe.Http;
import haxe.Json;

#if js
import js.Dom;
#end

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

#if !js
class JsonLoader<T : Dynamic> {

    private var _uriLoader : UriLoader<T>;

    public function new(request : UriRequest) {
        _uriLoader = new UriLoader(request, function(value) {
            return try {
                Json.parse(value);
            } catch (error : Dynamic) {
                Funk.error(HttpError("Error parsing the Json"));
            }
        });
    }

    public function start(method : HttpMethod) : Promise<T> {
        return _uriLoader.start(method);
    }

    public function stop() : Promise<T> {
        return _uriLoader.stop();
    }

    public function status() : Stream<Option<HttpStatusCode>> {
        return _uriLoader.status();
    }
}
#else
class JsonLoader<T : Dynamic> {

    private var _request : UriRequest;

    private var _requestId : String;

    private var _requestUri : Option<String>;

    private var _deferred : Deferred<T>;

    private var _states : Collection<State<T>>;

    private var _statusStream : Stream<Option<HttpStatusCode>>;

    public function new(request : UriRequest) {
        _request = request;

        _deferred = new Deferred();
        _states = _deferred.states();

        _statusStream = Streams.identity(None);
        _statusStream.dispatch(None);

        var callbackName = "callback";

        // Convert the possible headers into an option and then loop over it.
        request.headers().foreach(function (list) {
            var custom = list.find(function(header) {
                return switch(header.getHttpCustomRequest()) {
                    case Some(tuple): (tuple._1() == "x-callback");
                    case None: false;
                };
            });

            callbackName = switch (custom) {
                case Some(header):
                    switch(header.getHttpCustomRequest()) {
                        case Some(tuple): tuple._2();
                        case None: callbackName;
                    }
                case None: callbackName;
            };
        });

        // Get the request path.
        var tuple = JsonpLoaderResponder.create(function(data) {
            try {
                // Wait to make sure we can parse before sending the OK
                _statusStream.dispatch(HttpSuccess(OK).toOption());
                _deferred.resolve(data);
            } catch (error : Dynamic) {
                _statusStream.dispatch(HttpSuccess(NoContent).toOption());
                _deferred.reject(HttpError("Error parsing data format"));
            }
        });

        // Merge the url and parameters
        _requestId = tuple._1();
        _requestUri = switch(_request.url()) {
            case Some(url):

                var parameters = _request.parameters().map(function(tuple) {
                    var key = tuple._1();
                    return switch (tuple._2()) {
                        case Some(value): Std.format("${key}=${value}");
                        case None: Std.format("${key}");
                    };
                }).foldLeft("", function(value, param) {
                    return Std.format("${value}&${param}");
                });

                var requestCallbackPath = tuple._2();
                var complied = switch(parameters) {
                    case Some(value): Std.format("${value}&${callbackName}=${requestCallbackPath}");
                    case None: Std.format("${callbackName}=${requestCallbackPath}");
                };

                Some(Std.format("${url}?${complied}"));
            case None:
                _statusStream.dispatch(HttpClientError(NotFound).toOption());
                _deferred.reject(HttpError("No valid url supplied"));
                None;
        }
    }

    public function start(method : HttpMethod) : Promise<T> {
        var promise = _deferred.promise();

        if (_states.contains(Aborted)) {
            return promise;
        }

        switch (method) {
            case Get:
            default:
                _statusStream.dispatch(HttpClientError(Failure).toOption());
                _deferred.reject(HttpError(Std.format("Error at: ${Std.string(method)} not supported")));
        };

        switch (_requestUri) {
            case Some(uri):
                try {
                    JsonpLoaderResponder.inject(uri, _requestId);
                } catch (error : Dynamic) {
                    _statusStream.dispatch(HttpClientError(Failure).toOption());
                    _deferred.reject(HttpError(Std.format("Error at: ${Std.string(error)}")));
                }
            case None:
                _statusStream.dispatch(HttpClientError(NotFound).toOption());
                _deferred.reject(HttpError(Std.format("No valid url supplied")));
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

@:expose('funk.io.http.JsonpLoaderResponder')
class JsonpLoaderResponder {

    public static var requests : Dynamic = {};

    public static var requestSeed : Int = Math.floor(Math.random() * 2147483647);

    public static var requestCount : Int = 0;

    private static var window : Window = untyped __js__("window");

    public static function create(func : Function1<Dynamic, Void>) : Tuple2<String, String> {
        var requestName = requestSeed + (requestCount++);
        var requestCallback = Std.format("jsonp_callback_${requestName}");
        var requestCallbackPath = Std.format("funk.io.http.JsonpLoaderResponder.requests.${requestCallback}");

        Reflect.setField(requests, requestCallback, function(data) {
            remove(requestCallback);
            func(data);
        });

        return tuple2(requestCallback, requestCallbackPath);
    }

    public static function inject(uri : String, id : String) : Void {
        var element = window.document.createElement('script');

        element.setAttribute('type', 'text/javascript');
        element.setAttribute('src', uri);
        element.setAttribute('id', id);

        switch(window.document.getElementsByTagName('head').toOption()) {
            case Some(collection):
                var length = collection.length;
                if(length > 0) {
                    var head = collection[0];
                    head.appendChild(element);
                } else if(length == 0) {
                    Funk.error(NoSuchElementError);
                }
            case None: Funk.error(NoSuchElementError);
        }
    }

    public static function remove(id : String) : Void {
        var element = window.document.getElementById(id).toOption();
        switch(element) {
            case Some(value): value.parentNode.removeChild(value);
            case None:
        }

        Reflect.deleteField(requests, id);
    }
}
#end
