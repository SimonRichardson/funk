package funk.io.http;

import funk.Funk;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpResponse;
import funk.net.http.HttpStatusCode;
import funk.net.http.UriRequest;
import funk.reactives.Stream;
import funk.futures.Deferred;
import funk.futures.Promise;
import funk.types.Option;
import haxe.Http;

class XmlLoader {

    private var _uriLoader : UriLoader<Xml>;

    public function new(request : UriRequest) {
        _uriLoader = new UriLoader(request, function(value) {
            return try Xml.parse(value) catch (error : Dynamic) {
                Funk.error(HttpError("Error parsing the Xml"));
            }
        });
    }

    public function start(method : HttpMethod) : Promise<HttpResponse<Xml>> return _uriLoader.start(method);

    public function stop() : Promise<HttpResponse<Xml>> return _uriLoader.stop();

    public function status() : Stream<Option<HttpStatusCode>> return _uriLoader.status();
}
