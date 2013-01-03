package funk.net.http.extensions;

class UriRequests {

    public static function fromUri(uri : String) : UriRequest {
        return UriRequest(uri);
    }

    public static function get<T>(request : UriRequest) : Promise<T> {

    }

    public static function post<T>(request : UriRequest) : Promise<T> {

    }
}
