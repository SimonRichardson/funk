package funk.io.http.extensions;

import funk.io.http.JsonLoader;
import funk.io.http.Loader;
import funk.io.http.MimeType;
import funk.io.http.UriLoader;
import funk.io.http.XmlLoader;
import funk.net.http.UriRequest;

using funk.io.http.extensions.MimeTypes;
using funk.types.extensions.Anys;

class Loaders {

	public static function loader<T>(request : UriRequest, mime : MimeType) : Loader<T> {
		if (!mime.toBool()) {
            mime = Content(Text(Plain));
        }

        return if (mime.isJson()) {
            cast new JsonLoader(request);
        } else if(mime.isText()) {
        	cast new UriLoader(request, function (value) {
        		return value;
        	});
        } else if(mime.isXml()) {
        	cast new XmlLoader(request);
        } else {
        	Funk.error(ArgumentError("Unsupported MimeType"));
        }
	}
}