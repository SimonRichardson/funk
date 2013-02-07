package funk.net.http.extensions;

import funk.types.Option;
import funk.types.Tuple2;
import funk.types.extensions.Strings;

using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class HttpHeaders {

    public static function isHttpRequest(value : HttpHeader) : Bool {
        return switch(value) {
            case HttpRequest(_): true;
            default: false;
        }
    }

    public static function isHttpResponse(value : HttpHeader) : Bool {
        return switch(value) {
            case HttpResponse(_): true;
            default: false;
        }
    }

    public static function getHttpCustomRequest(value : HttpHeader) : Option<Tuple2<String, String>> {
        return switch(value) {
            case HttpRequest(request): 
                switch(request) {
                    case X(a, b): Some(tuple2(a, b));
                    default: None;
                }
            default: None;
        }
    }

    public static function getHttpCustomResponse(value : HttpHeader) : Option<Tuple2<String, String>> {
        return switch(value) {
            case HttpResponse(response): 
                switch(response) {
                    case X(a, b): Some(tuple2(a, b));
                    default: None;
                }
            default: None;
        }
    }

    public static function toHttpVersion(value : HttpHeader) : HttpVersion {
        return switch(value) {
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
                    case X(_, _): Unknown("");
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
                    case X(_, _): Unknown("");
                }
        }
    }

    public static function toTuple(value : HttpHeader) : Tuple2<String, String> {
        function getName(name : String) : String {
            var index = name.indexOf("(");
            return Strings.camelCaseToDashes(name.substr(0, index <= 0 ? name.length : index));
        }

        var name : Option<String> = None;
        var argument : Option<String> = None;

        switch (value) {
            case HttpRequest(request):
                name = Some(getName(Std.string(request)));

                switch (request) {
                    case Accept(v): Some(v);
                    case AcceptCharset(v): Some(v);
                    case AcceptEncoding(v): Some(v);
                    case AcceptLanguage(v): Some(v);
                    case AcceptDatetime(v): Some(Std.string(v));
                    case Authorization(v): Some(v);
                    case Cookie(v): Some(v);
                    case ContentLength(v): Some(Std.string(v));
                    case ContentMD5(v): Some(v);
                    case ContentType(v): Some(v);
                    case DateTime(v): Some(Std.string(v));
                    case Expect(v): Some(v);
                    case From(v): Some(v);
                    case Host(v): Some(v);
                    case IfMatch(v): Some(v);
                    case IfModifiedSince(v): Some(Std.string(v));
                    case IfNoneMatch(v): Some(v);
                    case IfRange(v): Some(v);
                    case IfUnmodifiedSince(v): Some(Std.string(v));
                    case MaxForwards(v): Some(Std.string(v));
                    case Pragma(v): Some(v);
                    case ProxyAuthorization(v): Some(v);
                    case Range(v): Some(v);
                    case Referer(v): Some(v);
                    case TE(v): Some(v);
                    case Upgrade(v): Some(v);
                    case UserAgent(v): Some(v);
                    case Via(v): Some(v);
                    case Warning(v): Some(v);
                    case X(name, value): Some(Std.format("${name},${value}"));
                }
            case HttpResponse(response):
                name = Some(getName(Std.string(response)));

                switch(response) {
                    case AccessControlAllowOrigin(v): Some(v);
                    case AcceptRanges(v): Some(v);
                    case Age(v): Some(Std.string(v));
                    case Allow(v): Some(v);
                    case CacheControl(v): Some(v);
                    case Connection(v): Some(v);
                    case ContentEncoding(v): Some(v);
                    case ContentLanguage(v): Some(v);
                    case ContentLength(v): Some(Std.string(v));
                    case ContentLocation(v): Some(v);
                    case ContentMD5(v): Some(v);
                    case ContentRange(v): Some(v);
                    case ContentType(v): Some(v);
                    case DateTime(v): Some(Std.string(v));
                    case ETag(v): Some(v);
                    case Expires(v): Some(Std.string(v));
                    case LastModified(v): Some(Std.string(v));
                    case Link(v): Some(v);
                    case Location(v): Some(v);
                    case P3P(v): Some(v);
                    case Pragma(v): Some(v);
                    case ProxyAuthenticate(v): Some(v);
                    case Refresh(v): Some(v);
                    case RetryAfter(v): Some(Std.string(v));
                    case Server(v): Some(v);
                    case SetCookie(v): Some(v);
                    case StrictTransportSecurity(v): Some(v);
                    case Trailer(v): Some(v);
                    case TransferEncoding(v): Some(v);
                    case Vary(v): Some(v);
                    case Via(v): Some(v);
                    case Warning(v): Some(v);
                    case WWWAuthenticate(v): Some(v);
                    case X(name, value): Some(Std.format("${name},${value}"));
                }
        }

        return tuple2(name.getOrElse(Strings.identity), argument.getOrElse(Strings.identity));
    }

    public static function toString(value : HttpHeader) : String {
        var tuple = toTuple(value);
        return Std.format("${tuple._1()}: ${tuple._2()}");
    }
}
