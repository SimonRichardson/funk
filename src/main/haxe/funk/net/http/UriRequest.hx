package funk.net.http;

import funk.collections.immutable.List;
import funk.net.http.HttpHeader;

enum UriRequest {
    Request(uri : String);
    RequestWithHeaders(uri : String, headers : List<HttpHeader>);
}
