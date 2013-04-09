package funk.net.http;

enum HttpVersion {
    Http(version : String);
    WebDav(version : String);
    Unknown(value : String);
}

class HttpVersionTypes {

    public static function version(value : HttpVersion) : String {
        return switch (value) {
            case Http(version): version;
            case WebDav(version): version;
            case Unknown(version): version;
        }
    }

    public static function toString(value : HttpVersion) : String {
        return switch (value) {
            case Http(version): 'HTTP/$version';
            case WebDav(version): 'WebDav/$version';
            case Unknown(version): '$version';
        }
    }
}
