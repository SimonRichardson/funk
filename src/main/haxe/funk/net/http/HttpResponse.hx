package funk.net.http;

import funk.collections.immutable.List;
import funk.types.Option;

typedef HttpResponse<T> = {
	code : Option<HttpStatusCode>,
	body : Option<T>,
	headers : List<HttpHeader>
}