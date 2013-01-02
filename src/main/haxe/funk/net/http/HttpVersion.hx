package funk.net.http;

enum HttpVersion {
    Http(version : String);
    WebDav(version : String);
    Unknown(value : String);
}
