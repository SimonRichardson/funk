package funk.net.http;

import funk.collections.immutable.List;

enum UriRequest {
    Request(uri : String);
    RequestWithHeaders(uri : String, headers : List<HttpHeader>);
}
