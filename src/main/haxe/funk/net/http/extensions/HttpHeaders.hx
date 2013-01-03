package funk.net.http.extensions;

import funk.types.extensions.Strings;

class HttpHeaders {

    public static function isHttpRequest(code : HttpHeader) : Bool {
        return switch(code) {
            case HttpRequest(_): true;
            default: false;
        }
    }

    public static function isHttpResponse(code : HttpHeader) : Bool {
        return switch(code) {
            case HttpResponse(_): true;
            default: false;
        }
    }

    public static function toHttpVersion(value : HttpHeader) : HttpVersion {
        return switch(code) {
            case HttpRequest(request):
                switch(request) {
                    case Accept(_): Http("1.1");
                    case AcceptCharset(_): Http("1.1");
                    case AcceptEncoding(_): Http("1.1");
                    case AcceptLanguage(_): Http("1.1");
                    case AcceptDatetime(_): Http("1.1");
                    case Authorization(_): Http("1.0");
                    case Cookie(_): Http("1.0");
                    case ContentLength(_): Http("1.0");
                    case ContentMD5(_): Http("1.1");
                    case ContentType(_): Http("1.0");
                    case DateTime(_): Http("1.0");
                    case Expect(_): Http("1.1");
                    case From(_): Http("1.0");
                    case Host(_): Http("1.1");
                    case IfMatch(_): Http("1.1");
                    case IfModifiedSince(_): Http("1.0");
                    case IfNoneMatch(_): Http("1.1");
                    case IfRange(_): Http("1.1");
                    case IfUnmodifiedSince(_): Http("1.1");
                    case MaxForwards(_): Http("1.1");
                    case Pragma(_): Http("1.0");
                    case ProxyAuthorization(_): Http("1.1");
                    case Range(_): Http("1.1");
                    case Referer(_): Http("1.0");
                    case TE(_): Http("1.1");
                    case Upgrade(_): Http("1.1");
                    case UserAgent(_): Http("1.0");
                    case Via(_): Http("1.1");
                    case Warning(_): Http("1.1");
                }

            case HttpResponse(response):
                switch(response) {
                    case AccessControlAllowOrigin(_): Http("1.1");
                    case AcceptRanges(_): Http("1.1");
                    case Age(_): Http("1.1");
                    case Allow(_): Http("1.0");
                    case CacheControl(_): Http("1.0");
                    case Connection(_): Http("1.1");
                    case ContentEncoding(_): Http("1.0");
                    case ContentLanguage(_): Http("1.1");
                    case ContentLength(_): Http("1.0");
                    case ContentLocation(_): Http("1.1");
                    case ContentMD5(_): Http("1.1");
                    case ContentRange(_): Http("1.1");
                    case ContentType(_): Http("1.0");
                    case DateTime(_): Http("1.0");
                    case ETag(_): Http("1.1");
                    case Expires(_): Http("1.0");
                    case LastModified(_): Http("1.0");
                    case Link(_): Http("1.0");
                    case Location(_): Http("1.0");
                    case P3P(_): Http("1.0");
                    case Pragma(_): Http("1.0");
                    case ProxyAuthenticate(_): Http("1.1");
                    case Refresh(_): Http("1.0");
                    case RetryAfter(_): Http("1.1");
                    case Server(_): Http("1.0");
                    case SetCookie(_): Http("1.0");
                    case StrictTransportSecurity(_): Http("1.0");
                    case Trailer(_): Http("1.1");
                    case TransferEncoding(_): Http("1.1");
                    case Vary(_): Http("1.1");
                    case Via(_): Http("1.1");
                    case Warning(_): Http("1.1");
                    case WWWAuthenticate(_): Http("1.0");
                }
        }
    }

    public static function toString(value : HttpHeader) : String {
        function getName(name) {
            var index = name.indexOf("(");
            return Strings.camelCaseToDashes(name.substr(0, index <= 0 ? name.length : index));
        }

        return switch (value) {
            case HttpRequest(request):
                getName(Std.string(request));

            case HttpResponse(response):
                getName(Std.string(response));
        }
    }
}
