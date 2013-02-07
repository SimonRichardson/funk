package funk.io.http;

import funk.Funk;
import funk.net.http.HttpStatusCode;
import funk.reactive.Stream;
import funk.types.Promise;
import funk.types.Option;
import haxe.Http;

typedef Loader<T> = {

	function start(method : HttpMethod) : Promise<T>;

    function stop() : Promise<T>;

    function status() : Stream<Option<HttpStatusCode>>;
}