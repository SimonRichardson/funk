package funk.net.http.extensions;

import funk.net.http.HttpVersion;

class HttpVersions {

    public static function version(value : HttpVersion) : String {
        return switch (value) {
            case Http(version): version;
            case WebDav(version): version;
            case Unknown(version): version;
        }
    }

    public static function toString(value : HttpVersion) : String {
        return switch (value) {
            case Http(version): Std.format("HTTP/$version");
            case WebDav(version): Std.format("WebDav/$version");
            case Unknown(version): Std.format("$version");
        }
    }
}
