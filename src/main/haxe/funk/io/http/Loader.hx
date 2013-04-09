package funk.io.http;

import funk.Funk;
import funk.net.http.HttpStatusCode;
import funk.net.http.HttpResponse;
import funk.net.http.HttpMethod;
import funk.reactives.Stream;
import funk.futures.Promise;
import funk.types.Option;
import funk.net.http.UriRequest;
import haxe.Http;

using funk.io.http.MimeType;
using funk.types.Any;

typedef Loader<T> = {

    function start(method : HttpMethod) : Promise<HttpResponse<T>>;

    function stop() : Promise<HttpResponse<T>>;

    function status() : Stream<Option<HttpStatusCode>>;
}

class LoaderTypes {

    public static function loader<T>(request : UriRequest, mime : MimeType) : Loader<T> {
        if (!mime.toBool()) {
            mime = Content(Text(Plain));
        }

        return if (mime.isJson()) cast new JsonLoader(request);
        else if(mime.isXml()) cast new XmlLoader(request);
        else if(mime.isText()) cast new UriLoader(request, function (value) return value);
        else Funk.error(ArgumentError("Unsupported MimeType"));
    }
}
