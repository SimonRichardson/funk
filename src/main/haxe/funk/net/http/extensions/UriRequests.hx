package funk.net.http.extensions;

import funk.net.http.HttpMethod;

class UriRequests {

    public static function uri(request : UriRequest) : String {
        return Type.enumParameters(request)[0];
    }

    public static function fromUri(value : String) : UriRequest {
        return UriRequest(value);
    }

    public static function get<T>(request : UriRequest) : Promise<T> {
        return new Http(request).load(Get);
    }

    public static function post<T>(request : UriRequest) : Promise<T> {
        return new Http(request).load(Post);
    }
}
