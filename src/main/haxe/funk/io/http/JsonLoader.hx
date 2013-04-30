package funk.io.http;

import funk.Funk;
import funk.net.http.HttpMethod;
import funk.net.http.HttpResponse;
import funk.futures.Deferred;
import funk.futures.Promise;
import funk.types.Function1;
import funk.types.Option;
import funk.types.Tuple2;
import haxe.Http;
import haxe.Json;

#if js
import js.Browser;
#end

using funk.net.http.HttpHeader;
using funk.net.http.HttpStatusCode;
using funk.net.http.UriRequest;
using funk.net.http.Uri;
using funk.reactives.Stream;
using funk.types.Option;
using funk.ds.Collection;
using funk.ds.immutable.List;
using funk.ds.immutable.Map;

#if !js
class JsonLoader<T : Dynamic> {

    private var _uriLoader : UriLoader<T>;

    public function new(request : UriRequest) {
        _uriLoader = new UriLoader(request, function(value) {
            return try Json.parse(value) catch (error : Dynamic) {
                Funk.error(HttpError("Error parsing the Json"));
            }
        });
    }

    public function start(method : HttpMethod) : Promise<HttpResponse<T>> return _uriLoader.start(method);

    public function stop() : Promise<HttpResponse<T>> return _uriLoader.stop();

    public function status() : Stream<Option<HttpStatusCode>> return _uriLoader.status();
}
#else
class JsonLoader<T : Dynamic> {

    private var _request : UriRequest;

    private var _requestId : String;

    private var _requestUri : Option<String>;

    private var _deferred : Deferred<HttpResponse<T>>;

    private var _states : Collection<State<HttpResponse<T>>>;

    private var _statusStream : Stream<Option<HttpStatusCode>>;

    public function new(request : UriRequest) {
        _request = request;

        _deferred = new Deferred();
        _states = _deferred.states();

        _statusStream = StreamTypes.identity(None);
        _statusStream.dispatch(None);

        var callbackName = "callback";

        // Convert the possible headers into an option and then loop over it.
        request.headers().foreach(function (list) {
            var custom = list.find(function(header) {
                return switch(header.getHttpCustomRequest()) {
                    case Some(tuple): (tuple._1() == "x-callback");
                    case _: false;
                };
            });

            callbackName = switch (custom) {
                case Some(header):
                    switch(header.getHttpCustomRequest()) {
                        case Some(tuple): tuple._2();
                        case _: callbackName;
                    }
                case _: callbackName;
            };
        });

        // Get the request path.
        var tuple = JsonpLoaderResponder.create(function(data) {
            try {
                // Wait to make sure we can parse before sending the OK
                var statusValue = HttpSuccess(OK).toOption();
                _statusStream.dispatch(statusValue);
                _deferred.resolve({
                    code: statusValue,
                    body: Some(data),
                    headers: ListType.Nil
                });
            } catch (error : Dynamic) {
                _statusStream.dispatch(HttpSuccess(NoContent).toOption());
                _deferred.reject(HttpError("Error parsing data format"));
            }
        });

        // Merge the url and parameters
        _requestId = tuple._1();
        _requestUri = switch(_request.url()) {
            case Some(url):

                var parameters = _request.parameters().list().map(function(tuple) {
                    var key = tuple._1();
                    return switch (tuple._2()) {
                        case Some(value): '${key}=${value}';
                        case _: '${key}';
                    };
                }).foldLeft("", function(value, param) {
                    return '${value}&${param}';
                });

                var requestCallbackPath = tuple._2();
                var complied = switch(parameters) {
                    case Some(value): '${value}&${callbackName}=${requestCallbackPath}';
                    case _: '${callbackName}=${requestCallbackPath}';
                };

                Some('${url}?${complied}');
            case _:
                _statusStream.dispatch(HttpClientError(NotFound).toOption());
                _deferred.reject(HttpError("No valid url supplied"));
                None;
        }
    }

    public function start(method : HttpMethod) : Promise<HttpResponse<T>> {
        var promise = _deferred.promise();

        if (_states.contains(Aborted)) return promise;

        switch (method) {
            case Get:
            case _:
                _statusStream.dispatch(HttpClientError(Failure).toOption());
                _deferred.reject(HttpError('Error at: ${Std.string(method)} not supported'));
        };

        switch (_requestUri) {
            case Some(uri):
                try JsonpLoaderResponder.inject(uri, _requestId) catch (error : Dynamic) {
                    _statusStream.dispatch(HttpClientError(Failure).toOption());
                    _deferred.reject(HttpError('Error at: ${Std.string(error)}'));
                }
            case _:
                _statusStream.dispatch(HttpClientError(NotFound).toOption());
                _deferred.reject(HttpError('No valid url supplied'));
        }

        return promise;
    }

    public function stop() : Promise<HttpResponse<T>> {
        _deferred.abort();

        return _deferred.promise();
    }

    public function status() : Stream<Option<HttpStatusCode>> return _statusStream;
}

@:expose('funk.io.http.JsonpLoaderResponder')
class JsonpLoaderResponder {

    public static var requests : Dynamic = {};

    public static var requestSeed : Int = Math.floor(Math.random() * 2147483647);

    public static var requestCount : Int = 0;

    public static function create(func : Function1<Dynamic, Void>) : Tuple2<String, String> {
        var requestName = requestSeed + (requestCount++);
        var requestCallback = 'jsonp_callback_${requestName}';
        var requestCallbackPath = 'funk.io.http.JsonpLoaderResponder.requests.${requestCallback}';

        Reflect.setField(requests, requestCallback, function(data) {
            remove(requestCallback);
            func(data);
        });

        return tuple2(requestCallback, requestCallbackPath);
    }

    public static function inject(uri : String, id : String) : Void {
        var window = Browser.window;
        var element = window.document.createElement('script');

        element.setAttribute('type', 'text/javascript');
        element.setAttribute('src', uri);
        element.setAttribute('id', id);

        switch(window.document.getElementsByTagName('head').toOption()) {
            case Some(collection) if(collection.length > 0):
                var head = collection[0];
                head.appendChild(element);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public static function remove(id : String) : Void {
        var window = Browser.window;
        var element = window.document.getElementById(id).toOption();
        switch(element) {
            case Some(value): value.parentNode.removeChild(value);
            case _:
        }

        Reflect.deleteField(requests, id);
    }
}
#end
