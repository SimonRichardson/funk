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
            case Http(version): 'HTTP/$version';
            case WebDav(version): 'WebDav/$version';
            case Unknown(version): '$version';
        }
    }
}
