package funk.io.http;

import funk.Funk;
import funk.net.http.HttpStatusCode;
import funk.net.http.HttpResponse;
import funk.net.http.HttpMethod;
import funk.reactive.Stream;
import funk.types.Promise;
import haxe.ds.Option;
import haxe.Http;

typedef Loader<T> = {

	function start(method : HttpMethod) : Promise<HttpResponse<T>>;

    function stop() : Promise<HttpResponse<T>>;

    function status() : Stream<Option<HttpStatusCode>>;
}
